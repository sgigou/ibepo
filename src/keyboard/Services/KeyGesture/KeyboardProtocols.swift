//
//  KeyboardActionProtocol.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-14.
//  Copyright © 2020 Novesoft. All rights reserved.
//


// MARK: - KeyboardActionProtocol

/// Protocol used to interact with the input field.
protocol KeyboardActionProtocol: class {
  
  /**
   Should insert some text.
   
   - parameter text: Text to insert.
   */
  func insert(text: String)
  
  /**
   Optional. Replaces the given amount on characters by the given text.
   */
  func replace(charactersAmount: Int, by text: String)
  
  /**
   Delete backward 1 character.
   */
  func deleteBackward()
  
  /**
   Delete several characters backward.
   
   - parameter amount: Amount of characters to delete.
   */
  func deleteBackward(amount: Int)
  
  /**
   Needs to switch keyboard
   */
  func nextKeyboard()
  
}

extension KeyboardActionProtocol {
  
  func replace(charactersAmount: Int, by text: String) {}
  
}


// MARK: - KeyboardDisplayProtocol

/// Protocol used to display changes on the keypad.
protocol KeyboardDisplayProtocol: class {
  
  /**
   Called when the shift key state changed.
   */
  func shiftStateChanged(newState: Key.State)
  
  /**
   Called when the alt key state changed.
   */
  func altStateChanged(newState: Key.State)
  
  /// No key should be pressed on the keyboard at this moment.
  func noKeyIsPressed()
  
  /// Called when a key is pressed by the user.
  func keyIsPressed(kind: Key.Kind, at coordinate: KeyCoordinate?)
  
}
