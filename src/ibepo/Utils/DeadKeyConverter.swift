//
//  DeadKeyConverter.swift
//  ibepo
//
//  Created by Steve Gigou on 29/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation

struct DeadKeyConverter {

  let accents = [
    "\u{0300}", // dead_grave `
    "\u{0301}", // dead_acute ´
    "\u{0302}", // dead_circumflex ^
    "\u{0303}", // dead_tilde ~
    "\u{0304}", // dead_macron ¯
    "\u{0306}", // dead_breve ˘
    "\u{0307}", // dead_abovedot ˙
    "\u{0308}", // dead_diaeresis ¨
    "\u{0309}", // dead_hook
    "\u{030a}", // dead_abovering °
    "\u{030b}", // dead_acute dead_acute ˝
    "\u{030c}", // dead_caron ˇ
    "\u{030f}", // dead_grave dead_grave
    "\u{0311}", // dead_breve dead_breve
    "\u{031b}", // dead_horn
    "\u{0323}", // dead_belowdot
    "\u{0324}", // dead_diaeresis dead_diaeresis
    "\u{0325}", // dead_abovering dead_abovering
    "\u{0326}", // dead_belowcomma
    "\u{0327}", // dead_cedilla
    "\u{0328}", // dead_ogonek
    "\u{032d}", // dead_circumflex dead_circumflex
    "\u{0331}", // dead_macron dead_macron
    "\u{0334}", // dead_tilde
    "\u{0336}", // UFDD8
    "\u{0338}", // dead_stroke
  ]

  let escapingCharacters = [
    " ",
    " ",
    " ",
    "\n",
    "\t",
  ]

  let doubleAccents = [
    "\u{0301}": "\u{030b}", // ´ -> ˝
    "\u{0300}": "\u{030f}", // dead_grave
    "\u{0306}": "\u{0311}", // dead_breve
    "\u{0308}": "\u{0324}", // dead_diaeresis
    "\u{030a}": "\u{0325}", // dead_abovering
    "\u{0302}": "\u{032d}", // dead_circumflex
    "\u{0304}": "\u{0331}", // dead_macron
    "\u{0303}": "\u{0334}", // dead_tilde
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

  let tildes = [
    "-": "≃",
    "<": "≲",
    ">": "≳",
    "=": "≈",
    "≠": "≉",
  ]

  func isModificativeLetter(_ letter: String) -> Bool {
    return accents.contains(letter)
  }

  func shouldEscape(markedText: String, with newLetter: String) -> Bool {
    return escapingCharacters.contains(newLetter)
  }

  func combine(markedText: String, with newLetter: String) -> String {
    if let doubleAccent = combineAccents(markedText: markedText, with: newLetter) {
      return doubleAccent
    }
    if let exponent = combineExponents(markedText: markedText, with: newLetter) {
      return exponent
    }
    if let tilde = combineTilde(markedText: markedText, with: newLetter) {
      return tilde
    }
    return combineStandard(markedText: markedText, with: newLetter)
  }

  private func combineAccents(markedText: String, with newLetter: String) -> String? {
    if let doubleAccent = doubleAccents[newLetter] {
      if newLetter.unicodeScalars.last == markedText.unicodeScalars.last {
        return doubleAccent
      }
    }
    return nil
  }

  private func combineExponents(markedText: String, with newLetter: String) -> String? {
    if markedText.unicodeScalars.last == "\u{0302}" {
      if let exponent = exponents[newLetter] {
        return exponent
      }
    }
    return nil
  }

  private func combineTilde(markedText: String, with newLetter: String) -> String? {
    if markedText.unicodeScalars.last == "\u{0303}" {
      if let tilde = tildes[newLetter] {
        return tilde
      }
    }
    return nil
  }

  private func combineStandard(markedText: String, with newLetter: String) -> String {
    guard let combiningChar = markedText.unicodeScalars.last else {
      return newLetter
    }
    return "\(newLetter)\(combiningChar)"
  }

}
