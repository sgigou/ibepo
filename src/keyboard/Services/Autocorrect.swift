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

final class Autocorrect {
  
  weak var delegate: AutocorrectProtocol?
  
  private(set) var correctionSet: CorrectionSet = .empty
  
  private let checker = UITextChecker()
  private let queue = DispatchQueue(label: "com.novesoft.ibepo.autocorrect")
  
  private var workItem: DispatchWorkItem?
  private var isSearching = false
  private var lastCorrectedWord: String?
  
  // MARK: User input
  
  func correction(for input: String) -> String? {
    lastCorrectedWord = nil
    if !KeyboardSettings.shared.shouldAutocorrect { return nil }
    if input.count != 1 { return nil }
    let character = input.first!
    if character.isLetter || ["’", "'", "-"].contains(character) { return nil }
    let correction = correctionSet.preferredCorrection
    if let correction = correction {
      lastCorrectedWord = correctionSet.correction1?.word
      let replacement = "\(correction.word)\(character)"
      return replacement
    }
    return nil
  }
  
  func update() {
    launchSearch()
  }
  
  // MARK: Autocorrect
  
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
  
  private func loadSuggestions() {
    let currentWord = KeyboardSettings.shared.textDocumentProxyAnalyzer.currentWord
    if currentWord == "" {
      return emptyCorrections()
    }
    let wordToCorrect = lastCorrectedWord ?? currentWord
    let range = NSRange(location: 0, length: wordToCorrect.count)
    let wordExists = checker.rangeOfMisspelledWord(in: wordToCorrect, range: range, startingAt: 0, wrap: false, language: "fr").length == 0
    let guesses = checker.guesses(forWordRange: range, in: wordToCorrect, language: "fr") ?? []
    let completions = checker.completions(forPartialWordRange: range, in: wordToCorrect, language: "fr") ?? []
    sortCorrections(enteredWord: wordToCorrect, guesses: guesses, completions: completions, enteredWordExists: wordExists)
    if currentWord != "" {
      lastCorrectedWord = nil
    }
  }
  
  private func emptyCorrections() {
    correctionSet = .empty
    isSearching = false
    delegate?.autocorrectEnded(with: correctionSet)
  }
  
  private func sortCorrections(enteredWord: String, guesses: [String], completions: [String], enteredWordExists: Bool) {
    let prefersEnteredWord = prefers(enteredWordExists: enteredWordExists, guessesIsEmpty: guesses.isEmpty, completionsIsEmpty: completions.isEmpty)
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
    isSearching = false
    delegate?.autocorrectEnded(with: correctionSet)
  }
  
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
  
  /// Determines if the currently entered text should be the preferred correction.
  private func prefers(enteredWordExists: Bool, guessesIsEmpty: Bool, completionsIsEmpty: Bool) -> Bool {
    if !KeyboardSettings.shared.shouldAutocorrect { return true }
    if enteredWordExists { return true }
    if lastCorrectedWord != nil { return true }
    return guessesIsEmpty && completionsIsEmpty
  }
  
}
