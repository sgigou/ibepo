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
  
  /// The type of the letter
  enum Kind {
    
    case letter, shift, delete, alt, next, space, enter
    
    /// Indicates if the current kind is a modifier one.
    var isModifier: Bool {
      return self == .shift || self == .alt || self == .next
    }
    
  }
  
  enum State {
    case off, on
    
    var isActive: Bool {
      return self != .off
    }
    
    mutating func toggle() {
      switch self {
      case .on:
        self = .off
      case .off:
        self = .on
      }
    }
  }
  
  /// List of characters the view should display.
  let set: CharacterSet
  
  /// View that will display the characters of the set.
  let view: LetterKeyView
  
}
