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
    let correction1 = Correction(word: enteredWord, isPreferred: prefersEnteredWord, exists: enteredWordExists)
    let suggestions = sortSuggestions(currentWord: enteredWord, guesses: guesses, completions: completions)
    let correction2: Correction?
    if let suggestion2 = suggestions[safe: 0] {
      correction2 = Correction(word: suggestion2, isPreferred: !prefersEnteredWord, exists: true)
    } else {
      correction2 = nil
    }
    let correction3: Correction?
    if let suggestion3 = suggestions[safe: 1] {
      correction3 = Correction(word: suggestion3, isPreferred: false, exists: true)
    } else {
      correction3 = nil
    }
    correctionSet = CorrectionSet(correction1: correction1, correction2: correction2, correction3: correction3)
    // Logger.debug("Autocorrection ended with:\n1. \(correction1.description)\n2. \(correction2?.description ?? "nil")\n3. \(correction3?.description ?? "nil")")
    isSearching = false
    delegate?.autocorrectEnded(with: correctionSet)
  }
  
  /**
   Order suggestions by priority.
   */
  private func sortSuggestions(currentWord: String, guesses: [String], completions: [String]) -> [String] {
    var corrections = [String]()
    var i = 0
    while corrections.count < 2 {
      if i >= guesses.count && i >= completions.count {
        break
      }
      if let guess = guesses[safe: i] {
        if currentWord != guess && !corrections.contains(guess) {
          corrections.append(guess)
        }
      }
      if let completion = completions[safe: i] {
        if currentWord != completion && !corrections.contains(completion) {
          corrections.append(completion)
        }
      }
      i += 1
    }
    return corrections
  }
  
}
