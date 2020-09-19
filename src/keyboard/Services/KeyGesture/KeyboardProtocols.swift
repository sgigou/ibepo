//
//  KeyboardActionProtocol.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-14.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

// MARK: - KeyboardActionProtocol

/// Interaction with the input field.
protocol KeyboardActionProtocol: class {
  
  func insert(text: String)
  /// Optional
  func replace(charactersAmount: Int, by text: String, separator: String)
  func deleteBackward()
  func deleteBackward(amount: Int)
  func nextKeyboard()
  /// Optional
  func moveCursor(by offset: Int)
  
}

extension KeyboardActionProtocol {
  
  func replace(charactersAmount: Int, by text: String, separator: String) {}
  func moveCursor(by offset: Int) {}
  
}


// MARK: - KeyboardDisplayProtocol

/// Display changes on the keypad.
protocol KeyboardDisplayProtocol: class {
  func shiftStateChanged(newState: Key.State)
  func altStateChanged(newState: Key.State)
  func noKeyIsPressed()
  func keyIsPressed(kind: Key.Kind, at coordinate: KeyCoordinate?)
  func launchSubLetterSelection(for key: Key, shiftState: Key.State, altState: Key.State)
  func select(subLetter: String)
}

// MARK: - KeyboardSwitchProtocol

/// Allow to keep track of switch keyboard button.
protocol KeyboardSwitchProtocol: class {
  func switchKeyAdded(_ switchButton: UIView)
}
