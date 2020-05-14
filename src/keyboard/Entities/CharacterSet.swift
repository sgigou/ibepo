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
  
  /// Letter to display when Shift is activated (it should appear in primaryAdditions if not nil).
  let primaryShiftLetter: String
  
  /// Letters to display when the key is long pressed.
  let primaryAdditions: [String]?
  
  // MARK: Secondary letters
  
  /// Alt letter of the key
  let secondaryLetter: String
  
  /// Letter to display when Alt and Shift are activated (it should appear in secondaryAdditions if not nil).
  let secondaryShiftLetter: String
  
  /// Letters to display when the key is long pressed with Alt activated.
  let secondaryAdditions: [String]?
  
  // MARK: Life cycle
  
  init(
    _ primaryLetter: String, _ primaryShiftLetter: String?, _ primaryAdditions: [String]?,
    _ secondaryLetter: String, _ secondaryShiftLetter: String?, _ secondaryAdditions: [String]?
  ) {
    self.primaryLetter = primaryLetter
    self.primaryShiftLetter = primaryShiftLetter ?? primaryLetter.uppercased()
    self.primaryAdditions = primaryAdditions
    self.secondaryLetter = secondaryLetter
    self.secondaryShiftLetter = secondaryShiftLetter ?? secondaryLetter.uppercased()
    self.secondaryAdditions = secondaryAdditions
  }
  
  
  // MARK: Find letters
  
  func letter(forShiftState shiftState: Key.State, andAltState altState: Key.State) -> String {
    switch altState {
    case .off:
      return primaryLetter(forShiftState: shiftState)
    case .on:
      return secondaryLetter(forShiftState: shiftState)
    }
  }
  
  func primaryLetter(forShiftState shiftState: Key.State) -> String {
    switch shiftState {
    case .off:
      return primaryLetter
    case .on:
      return primaryShiftLetter
    }
  }
  
  func secondaryLetter(forShiftState shiftState: Key.State) -> String {
    switch shiftState {
    case .off:
      return secondaryLetter
    case .on:
      return secondaryShiftLetter
    }
  }
  
}
