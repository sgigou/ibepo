//
//  Autocorrect.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - AutocorrectProtocol

protocol AutocorrectProtocol: class {
  func autocorrectEnded(with correctionSet: CorrectionSet)
}


// MARK: - Autocorrect

/// Autocorrect engine.
final class Autocorrect {
  
  var delegate: AutocorrectProtocol?
  
  /// Current correction set
  private(set) var correctionSet: CorrectionSet = .empty
  
  /// Text checker.
  private let checker = UITextChecker()
  /// Queue used to perform check
  private let queue = DispatchQueue(label: "com.novesoft.ibepo.autocorrect")
  
  /// Queue to look for words
  private var workItem: DispatchWorkItem?
  /// Indicates if a search is running in background.
  private var isSearching = false
  
  
  // MARK: User input
  
  /**
   Recalculates corrections.
   
   - parameter text: The entered text, if any.
   */
  func update(_ text: String? = nil) {
    launchSearch()
  }
  
  
  // MARK: Autocorrect
  
  /**
   Launches a search in background.
   */
  private func launchSearch() {
    if isSearching {
      Logger.debug("Cancelling running search")
      workItem?.cancel()
    }
    isSearching = true
    workItem = DispatchWorkItem() {
      [weak self] in
      self?.loadSuggestions()
    }
    queue.async(execute: workItem!)
  }
  
  /**
   Analyses the current word to find suggestions.
   */
  private func loadSuggestions() {
    let currentWord = KeyboardSettings.shared.textDocumentProxyAnalyzer.currentWord
    if currentWord == "" {
      return emptyCorrections()
    }
    let range = NSRange(location: 0, length: currentWord.count)
    let wordExists = checker.rangeOfMisspelledWord(in: currentWord, range: range, startingAt: 0, wrap: false, language: "fr").length == 0
    let guesses = checker.guesses(forWordRange: range, in: currentWord, language: "fr") ?? []
    let completions = checker.completions(forPartialWordRange: range, in: currentWord, language: "fr") ?? []
    sortCorrections(enteredWord: currentWord, guesses: guesses, completions: completions, enteredWordExists: wordExists)
  }
  
  /**
   Removes all corrections and notify the delegate.
   */
  private func emptyCorrections() {
    correctionSet = .empty
    isSearching = false
    delegate?.autocorrectEnded(with: correctionSet)
  }
  
  /**
   Sort corrections by probability and notify the delegate.
   */
  private func sortCorrections(enteredWord: String, guesses: [String], completions: [String], enteredWordExists: Bool) {
    let prefersEnteredWord = enteredWordExists || (guesses.isEmpty && completions.isEmpty)
    let correction1 = Correction(word: enteredWord, isPreferred: prefersEnteredWord, kind: .sic, exists: enteredWordExists)
    let correction2: Correction?
    if !guesses.isEmpty {
      correction2 = Correction(word: guesses.first!, isPreferred: !enteredWordExists, kind: .guess, exists: true)
    } else {
      if completions.count >= 2 {
        correction2 = Correction(word: completions[1], isPreferred: false, kind: .completion, exists: true)
      } else {
        correction2 = nil
      }
    }
    let correction3: Correction?
    if !completions.isEmpty {
      correction3 = Correction(word: completions.first!, isPreferred: !enteredWordExists && guesses.isEmpty, kind: .completion, exists: true)
    } else {
      if guesses.count >= 2 {
        correction3 = Correction(word: guesses[1], isPreferred: false, kind: .guess, exists: true)
      } else {
        correction3 = nil
      }
    }
    correctionSet = CorrectionSet(correction1: correction1, correction2: correction2, correction3: correction3)
    // Logger.debug("Autocorrection ended with:\n1. \(correction1.description)\n2. \(correction2?.description ?? "nil")\n3. \(correction3?.description ?? "nil")")
    isSearching = false
    delegate?.autocorrectEnded(with: correctionSet)
  }
  
}
