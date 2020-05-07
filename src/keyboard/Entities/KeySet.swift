//
//  KeySet.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

// MARK: - KeyCoordinate

/// A key position in a KeySet.
typealias KeyCoordinate = (row: Int, col: Int)


// MARK: - Row

/// A row in the KeySet.
typealias Row = [Key]


// MARK: - KeySet

/// A keypad configuration
struct KeySet {
  
  /// The letters on the keyboard.
  /// - warning: It does not contain special keys.
  let rows: [Row]
  
  
  // MARK: Key finding
  
  func key(at coordinate: KeyCoordinate) -> Key {
    let row = rows[coordinate.row]
    let key = row[coordinate.col]
    return key
  }
  
}
