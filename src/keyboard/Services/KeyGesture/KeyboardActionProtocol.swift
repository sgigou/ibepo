//
//  KeyboardActionProtocol.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-14.
//  Copyright © 2020 Novesoft. All rights reserved.
//

// MARK: - KeyStateDelegate

/// Protocol used to interact with the input field.
protocol KeyboardActionProtocol: class {
  
  /**
   Should insert some text.
   
   - parameter text: Text to insert.
   */
  func insert(text: String)
  
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
