//
//  Key.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

/// All the character set of a key.
struct CharacterSet {
  
  // MARK: Primary letters
  
  /// Main letter of the key.
  let primaryLetter: String
  
  /// Letter to display when Maj is activated (it should appear in primaryAdditions if not nil).
  let primaryMajLetter: String
  
  /// Letters to display when the key is long pressed.
  let primaryAdditions: [String]?
  
  // MARK: Secondary letters
  
  /// Alt letter of the key
  let secondaryLetter: String
  
  /// Letter to display when Alt and Maj are activated (it should appear in secondaryAdditions if not nil).
  let secondaryMajLetter: String
  
  /// Letters to display when the key is long pressed with Alt activated.
  let secondaryAdditions: [String]?
  
  // MARK: Life cycle
  
  init(
    _ primaryLetter: String, _ primaryMajLetter: String?, _ primaryAdditions: [String]?,
    _ secondaryLetter: String, _ secondaryMajLetter: String?, _ secondaryAdditions: [String]?
  ) {
    self.primaryLetter = primaryLetter
    self.primaryMajLetter = primaryMajLetter ?? primaryLetter
    self.primaryAdditions = primaryAdditions
    self.secondaryLetter = secondaryLetter
    self.secondaryMajLetter = secondaryMajLetter ?? secondaryLetter
    self.secondaryAdditions = secondaryAdditions
  }
  
}
