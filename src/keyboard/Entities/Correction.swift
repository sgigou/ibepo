//
//  Correction.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//


// MARK: - Correction

/// A correction proposed by the autocorrect engine.
struct Correction {
  
  /// Proposed word
  let word: String
  /// Indicates wether this correction is the preferred one
  let isPreferred: Bool
  /// Does the word exists in the dictionary
  let exists: Bool
  
  var description: String {
    return "Correction[word: \(word), isPreferred: \(isPreferred)]"
  }
  
}


// MARK: - CorrectionSet

struct CorrectionSet {
  
  let correction1: Correction?
  let correction2: Correction?
  let correction3: Correction?
  
  static var empty: CorrectionSet {
    return CorrectionSet(correction1: nil, correction2: nil, correction3: nil)
  }
  
}
