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
  
  /// Represents the state of a key.
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
