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
  
  enum Kind {
    case sic, guess, completion
  }
  
  /// Proposed word
  let word: String
  /// Indicates wether this correction is the preferred one
  let isPreferred: Bool
  /// What kind of correction is it
  let kind: Kind
  /// Does the word exists in the dictionary
  let exists: Bool
  
  var description: String {
    return "Correction[word: \(word), kind: \(kind), isPreferred: \(isPreferred)]"
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
