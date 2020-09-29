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
    // Row 4
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
