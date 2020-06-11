//
//  Correction.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//


// MARK: - Correction

struct Correction {
  
  let word: String
  let isPreferred: Bool
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
  
  var preferredCorrection: Correction? {
    if correction1?.isPreferred ?? false { return correction1 }
    if correction2?.isPreferred ?? false { return correction2 }
    return nil
  }
  
}
