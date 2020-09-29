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

  static let values: [UIKeyboardHIDUsage: KeyValue] = [
    // Row 1
    // Row 2
    .keyboardQ: KeyValue(standard: "b", shift: "B", alt: "|", shiftAlt: "_"),
    .keyboardW: KeyValue(standard: "é", shift: "É", alt: "\u{02ca}", shiftAlt: "♥"),
    // Row 3
    // Row 4
    // Row 5
    .keyboardSpacebar: KeyValue(standard: " ", shift: " ", alt: "_", shiftAlt: " "),
//    .keyboardW: KeyValue(standard: "", shift: "", alt: "", shiftAlt: ""),
  ]

  static func getEquivalentChar(for key: UIKey) -> String? {
    if key.modifierFlags.contains(.command) || key.modifierFlags.contains(.control) { return nil }
    guard let value = values[key.keyCode] else { return nil }
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
