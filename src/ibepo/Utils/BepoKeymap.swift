//
//  BepoKeymap.swift
//  ibepo
//
//  Created by Steve Gigou on 28/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

@available(iOS 13.4, *)
struct BepoKeymap {

  struct KeyValue {
    let standard: String
    let shift: String
    let alt: String
    let shiftAlt: String
  }

  static let values: [Int: KeyValue] = [
    // Row 1
    100: KeyValue(standard: "$", shift: "#", alt: "–", shiftAlt: "¶"),
    30: KeyValue(standard: "\"", shift: "1", alt: "—", shiftAlt: "„"),
    31: KeyValue(standard: "«", shift: "2", alt: "<", shiftAlt: "“"),
    32: KeyValue(standard: "»", shift: "3", alt: "&", shiftAlt: "”"),
    33: KeyValue(standard: "(", shift: "4", alt: "[", shiftAlt: "⩽"),
    34: KeyValue(standard: ")", shift: "5", alt: "]", shiftAlt: "⩾"),
    35: KeyValue(standard: "@", shift: "6", alt: "^", shiftAlt: ""),
    36: KeyValue(standard: "+", shift: "7", alt: "±", shiftAlt: "¬"),
    37: KeyValue(standard: "-", shift: "8", alt: "−", shiftAlt: "¼"),
    38: KeyValue(standard: "/", shift: "9", alt: "÷", shiftAlt: "½"),
    39: KeyValue(standard: "*", shift: "0", alt: "×", shiftAlt: "¾"),
    45: KeyValue(standard: "=", shift: "°", alt: "≠", shiftAlt: "′"),
    46: KeyValue(standard: "%", shift: "`", alt: "‰", shiftAlt: "″"),
    // Row 2
    20: KeyValue(standard: "b", shift: "B", alt: "|", shiftAlt: "_"),
    26: KeyValue(standard: "é", shift: "É", alt: "\u{0301}", shiftAlt: ""),
    8: KeyValue(standard: "p", shift: "P", alt: "&", shiftAlt: "§"),
    21: KeyValue(standard: "o", shift: "O", alt: "œ", shiftAlt: "Œ"),
    23: KeyValue(standard: "è", shift: "È", alt: "\u{0300}", shiftAlt: "`"),
    28: KeyValue(standard: "\u{0302}", shift: "!", alt: "¡", shiftAlt: ""),
    24: KeyValue(standard: "v", shift: "V", alt: "\u{030c}", shiftAlt: ""),
    12: KeyValue(standard: "d", shift: "D", alt: "", shiftAlt: ""),
    18: KeyValue(standard: "l", shift: "L", alt: "\u{0338}", shiftAlt: "£"),
    19: KeyValue(standard: "j", shift: "J", alt: "", shiftAlt: ""),
    47: KeyValue(standard: "z", shift: "Z", alt: "\u{0336}", shiftAlt: ""),
    48: KeyValue(standard: "w", shift: "W", alt: "", shiftAlt: ""),
    // Row 3
    4: KeyValue(standard: "a", shift: "A", alt: "æ", shiftAlt: "Æ"),
    22: KeyValue(standard: "u", shift: "U", alt: "ù", shiftAlt: "Ù"),
    7: KeyValue(standard: "i", shift: "I", alt: "\u{0308}", shiftAlt: "\u{0307}"),
    9: KeyValue(standard: "e", shift: "E", alt: "€", shiftAlt: ""),
    10: KeyValue(standard: ",", shift: ";", alt: "'", shiftAlt: "\u{0326}"),
    11: KeyValue(standard: "c", shift: "C", alt: "\u{0327}", shiftAlt: "©"),
    13: KeyValue(standard: "t", shift: "T", alt: "", shiftAlt: "™"),
    14: KeyValue(standard: "s", shift: "S", alt: "", shiftAlt: "ſ"),
    15: KeyValue(standard: "r", shift: "R", alt: "\u{0306}", shiftAlt: "®"),
    51: KeyValue(standard: "n", shift: "N", alt: "\u{0303}", shiftAlt: ""),
    52: KeyValue(standard: "m", shift: "M", alt: "\u{0304}", shiftAlt: ""),
    49: KeyValue(standard: "ç", shift: "Ç", alt: "", shiftAlt: "🄯"),
    // Row 4
    53: KeyValue(standard: "ê", shift: "Ê", alt: "/", shiftAlt: "^"),
    29: KeyValue(standard: "à", shift: "À", alt: "\\", shiftAlt: "‚"),
    27: KeyValue(standard: "y", shift: "Y", alt: "{", shiftAlt: "‘"),
    6: KeyValue(standard: "x", shift: "X", alt: "}", shiftAlt: "’"),
    25: KeyValue(standard: ".", shift: ":", alt: "…", shiftAlt: "·"),
    5: KeyValue(standard: "k", shift: "K", alt: "~", shiftAlt: "‑"),
    17: KeyValue(standard: "’", shift: "?", alt: "¿", shiftAlt: "\u{0309}"),
    16: KeyValue(standard: "q", shift: "Q", alt: "\u{030a}", shiftAlt: "\u{031b}"),
    54: KeyValue(standard: "g", shift: "G", alt: "", shiftAlt: "†"),
    55: KeyValue(standard: "h", shift: "H", alt: "\u{0323}", shiftAlt: "‡"),
    56: KeyValue(standard: "f", shift: "F", alt: "\u{0328}", shiftAlt: ""),
    // Row 5
    44: KeyValue(standard: " ", shift: " ", alt: "_", shiftAlt: " "),
//    .keyboardW: KeyValue(standard: "", shift: "", alt: "", shiftAlt: ""),
  ]

  static func getEquivalentChar(for key: UIKey) -> String? {
    if key.modifierFlags.contains(.command) || key.modifierFlags.contains(.control) { return nil }
    guard let value = values[key.keyCode.rawValue] else { return nil }
    let isShift = key.modifierFlags.contains(.alphaShift) ^ key.modifierFlags.contains(.shift)
    let isAlt = key.modifierFlags.contains(.alternate)
    if isShift && isAlt {
      return value.shiftAlt
    } else if isShift {
      return value.shift
    } else if isAlt {
      return value.alt
    } else {
      return value.standard
    }
  }

}
