//
//  DeadKeyConverter.swift
//  ibepo
//
//  Created by Steve Gigou on 29/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation

struct DeadKeyConverter {

  /// Matches modificative letter and combining char.
  ///
  /// Based on: https://bepo.fr/wiki/Touches_mortes
  let accentsMatchTable = [
    "\u{02cb}": "\u{0300}", // `
    "\u{02ca}": "\u{0301}", // ´
    "\u{02c6}": "\u{0302}", // ^
    "\u{02dc}": "\u{0303}", // ~
    "\u{02dd}": "\u{030b}", // ˝
  ]

  let doubleAccents = [
    "\u{02ca}": "\u{02dd}", // ´ -> ˝
  ]

  let exponents = [
    "1": "¹",
    "2": "²",
    "3": "³",
    "4": "⁴",
    "5": "⁵",
    "6": "⁶",
    "7": "⁷",
    "8": "⁸",
    "9": "⁹",
    "0": "⁰",
    "+": "⁺",
    "(": "⁽",
    ")": "⁾",
    "-": "⁻",
  ]

  func isModificativeLetter(_ letter: String) -> Bool {
    return accentsMatchTable[letter] != nil
  }

  func combine(markedText: String, with newLetter: String) -> String {
    // Validate base character
    // Double accents
    if let doubleAccent = doubleAccents[newLetter] {
      if newLetter == markedText {
        return doubleAccent
      }
    }
    // Exponents
    if markedText == "\u{02c6}" {
      if let exponent = exponents[newLetter] {
        return exponent
      }
    }
    // Standard accents
    guard let combiningChar = accentsMatchTable[markedText] else {
      return newLetter
    }
    return "\(newLetter)\(combiningChar)"
  }

}
