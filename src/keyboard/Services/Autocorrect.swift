//
//  Autocorrect.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - Autocorrect

/// Autocorrect engine.
final class Autocorrect {
  
  private let checker = UITextChecker()
  private let queue = DispatchQueue(label: "com.novesoft.ibepo.autocorrect")
  
  /// Queue to look for words
  private var workItem: DispatchWorkItem?
  /// Current autocorrected word
  private var currentWord: String = ""
  /// Indicates if a search is running in background.
  private var isSearching = false
  
  
  // MARK: User input
  
  /**
   Indicates that the user added a letter to the current word.
   */
  func insert(_ text: String) {
    if text == "" || text == "\n" {
      currentWord = ""
    } else {
      currentWord += text
      launchSearch()
    }
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
      Logger.debug("Looking for guesses for: \(self?.currentWord ?? "UNKNOWN")")
      self?.loadSuggestions()
    }
    queue.async(execute: workItem!)
  }
  
  /**
   Analyses the current word to find suggestions.
   */
  private func loadSuggestions() {
    let range = NSRange(location: 0, length: currentWord.count)
    let existingWord = checker.rangeOfMisspelledWord(in: currentWord, range: range, startingAt: 0, wrap: false, language: "fr").length == 0
    let guesses = checker.guesses(forWordRange: range, in: currentWord, language: "fr") ?? []
    let completions = checker.completions(forPartialWordRange: range, in: currentWord, language: "fr") ?? []
    isSearching = false
    Logger.debug("Spellcheck is over")
  }
  
}
