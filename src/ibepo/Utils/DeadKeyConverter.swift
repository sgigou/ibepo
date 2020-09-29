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

  func isModificativeLetter(_ letter: String) -> Bool {
    return accentsMatchTable[letter] != nil
  }

  func combine(markedText: String, with newLetter: String) -> String {
    guard let combiningChar = accentsMatchTable[markedText] else {
      return newLetter
    }
    return "\(newLetter)\(combiningChar)"
  }

}
