//
//  Key.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//


/// All the character set of a key.
struct KeyCharacterSet {
  
  // MARK: Primary letters
  
  /// Main letter of the key.
  let primaryLetter: String
  /// Letter to display when Shift is activated (it should appear in primaryAdditions if not nil).
  let primaryShiftLetter: String
  /// Letters to display when the key is long pressed.
  let primaryAdditions: [String]
  
  // MARK: Secondary letters
  
  /// Alt letter of the key
  let secondaryLetter: String
  /// Letter to display when Alt and Shift are activated (it should appear in secondaryAdditions if not nil).
  let secondaryShiftLetter: String
  /// Letters to display when the key is long pressed with Alt activated.
  let secondaryAdditions: [String]
  
  // MARK: Life cycle
  
  init(
    _ primaryLetter: String, _ primaryShiftLetter: String?, _ primaryAdditions: [String]?,
    _ secondaryLetter: String, _ secondaryShiftLetter: String?, _ secondaryAdditions: [String]?
  ) {
    self.primaryLetter = primaryLetter
    self.primaryShiftLetter = primaryShiftLetter ?? primaryLetter.uppercased()
    self.primaryAdditions = primaryAdditions ?? [primaryLetter]
    self.secondaryLetter = secondaryLetter
    self.secondaryShiftLetter = secondaryShiftLetter ?? secondaryLetter.uppercased()
    self.secondaryAdditions = secondaryAdditions ?? [secondaryLetter]
  }
  
  
  // MARK: Find letters
  
  func letter(forShiftState shiftState: Key.State, andAltState altState: Key.State) -> String {
    if altState.isActive {
      return secondaryLetter(forShiftState: shiftState)
    } else {
      return primaryLetter(forShiftState: shiftState)
    }
  }
  
  func subLetters(forShiftState shiftState: Key.State, andAltState altState: Key.State) -> [String] {
    if altState.isActive {
      if shiftState.isActive {
        return secondaryAdditions.map { $0.uppercased() }
      } else {
        return secondaryAdditions
      }
    } else {
      if shiftState.isActive {
        return primaryAdditions.map { $0.uppercased() }
      } else {
        return primaryAdditions
      }
    }
  }
  
  func primaryLetter(forShiftState shiftState: Key.State) -> String {
    if shiftState.isActive {
      return primaryShiftLetter
    } else {
      return primaryLetter
    }
  }
  
  func secondaryLetter(forShiftState shiftState: Key.State) -> String {
    if shiftState.isActive {
      return secondaryShiftLetter
    } else {
      return secondaryLetter
    }
  }
  
}
