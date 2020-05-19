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
  
}
