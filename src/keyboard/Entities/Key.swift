//
//  Key.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


/// A key set and its representing view.
struct Key {
  
  enum Kind {
    case letter, shift, delete, alt, next, space, enter
    
    var isModifier: Bool {
      return self == .shift || self == .alt || self == .next
    }
  }
  
  enum State {
    case off, on, locked
    
    var isActive: Bool {
      return self != .off
    }
    
    mutating func toggle() {
      switch self {
      case .on, .locked:
        self = .off
      case .off:
        self = .on
      }
    }
  }
  
  /// List of characters the view should display.
  let set: KeyCharacterSet
  
  /// View that will display the characters of the set.
  let view: LetterKeyView
  
}
