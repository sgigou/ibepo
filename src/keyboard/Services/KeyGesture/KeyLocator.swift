//
//  KeyLocator.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-25.
//  Copyright © 2020 Novesoft. All rights reserved.
//


/// Finds key type by their keypad coordinates.
final class KeyLocator {
  
  /**
   Get the kind of key at the given coordinate.
   */
  static func kind(at coordinate: KeypadCoordinate) -> Key.Kind {
    switch coordinate.row {
    case 0, 1: // First two rows only contain letters.
      return .letter
    case 2: // Shift, letters and Delete keys.
      switch coordinate.col {
      case 0...2: // Shift
        return .shift
      case 19...21: // Delete
        return .delete
      default: // Letter keys
        return .letter
      }
    case 3:
      switch coordinate.col {
      case 0...5:
        if KeyboardSettings.shared.needsInputModeSwitchKey {
          if coordinate.col <= 2 {
            return .alt
          } else {
            return .next
          }
        } else {
          return .alt
        }
      case 6...15:
        return .space
      case 16...22:
        return .enter
      default:
        Logger.error("Unknown keypadCoordinate col: \(coordinate)")
        return .space
      }
    default:
      Logger.error("Unknown keypadCoordinate row: \(coordinate)")
      return .space
    }
  }
  
  /// Calculates the key coordinate from the given keypad coordinate.
  static func calculateKeyCoordinate(for keypadCoordinate: KeypadCoordinate) -> KeyCoordinate {
    let col = keypadCoordinate.row == 2 ? (keypadCoordinate.col - 3) : keypadCoordinate.col
    let keyCoordinate = KeyCoordinate(row: keypadCoordinate.row, col: col / 2)
    return keyCoordinate
  }
  
}
