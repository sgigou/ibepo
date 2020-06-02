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
  
  func shiftStateChanged(newState: Key.State)
  func altStateChanged(newState: Key.State)
  func noKeyIsPressed()
  func keyIsPressed(kind: Key.Kind, at coordinate: KeyCoordinate?)
  func launchSubLetterSelection(for key: Key, shiftState: Key.State, altState: Key.State)
  func selectSubLetter(at index: Int)
  
}
