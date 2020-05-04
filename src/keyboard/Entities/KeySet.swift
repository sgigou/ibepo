//
//  KeySet.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

typealias Row = [Key]

/// A keypad configuration
struct KeySet {
  
  /// The letters on the keyboard.
  /// - warning: It does not contain special keys.
  let rows: [Row]
  
}
