//
//  KeyState.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-07.
//  Copyright © 2020 Novesoft. All rights reserved.
//

// MARK: - KeyStateDelegate

protocol KeyStateDelegate: class {
  func insert(text: String)
}

// MARK: - KeyState

/// Represents the keyboard state at any moment.
final class KeyState {
  
  weak var delegate: KeyStateDelegate?
  
  /// Currently displayed key set.
  private var keySet: KeySet!
  /// Gesture recognizer for keys
  private var gestureRecognizer: KeyGestureRecognizer!
  
  
  // MARK: Configuration
  
  func configure(keySet: KeySet, view: KeypadView) {
    self.keySet = keySet
    gestureRecognizer = KeyGestureRecognizer(delegate: self)
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  
  // MARK: Delegate communication
  
  private func tapLetter(at keyCoordinate: KeyCoordinate) {
    let key = keySet.key(at: keyCoordinate)
    delegate?.insert(text: key.set.primaryLetter)
  }
  
  private func tapSpace() {
    delegate?.insert(text: " ")
  }
  
}


// MARK: - KeyGestureRecognizerDelegate

extension KeyState: KeyGestureRecognizerDelegate {
  
  func touchUp(at keypadCoordinate: KeypadCoordinate) {
    switch keypadCoordinate.row {
    case 0, 1: // First two rows only contain letters.
      let keyCoordinate = KeyCoordinate(row: keypadCoordinate.row, col: keypadCoordinate.col / 2)
      tapLetter(at: keyCoordinate)
    case 2: // Shift, letters and Delete keys.
      switch keypadCoordinate.col {
      case 0...2: // Shift
        Logger.debug("Shift was tapped")
      case 19...21: // Delete
      Logger.debug("Delete was tapped")
      default: // Letter keys
        let keyCoordinate = KeyCoordinate(row: keypadCoordinate.row, col: (keypadCoordinate.col - 3) / 2)
        tapLetter(at: keyCoordinate)
      }
    case 3:
      switch keypadCoordinate.col {
      case 0...5:
        if KeyboardSettings.shared.needsInputModeSwitchKey {
          if keypadCoordinate.col <= 2 {
            Logger.debug("Alt was tapped")
          } else {
            Logger.debug("Switch was tapped")
          }
        } else {
          Logger.debug("Alt was tapped")
        }
      case 6...15:
        tapSpace()
      case 16...22:
        Logger.debug("Return was tapped")
      default:
        Logger.error("Unknown keypadCoordinate col: \(keypadCoordinate)")
      }
    default:
      Logger.error("Unknown keypadCoordinate row: \(keypadCoordinate)")
    }
  }
  
}
