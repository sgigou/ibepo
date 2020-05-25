//
//  KeyState.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-07.
//  Copyright © 2020 Novesoft. All rights reserved.
//

// MARK: - KeyState

/// Represents the keyboard state at any moment.
final class KeyState {
  
  weak var delegate: KeyboardActionProtocol?
  
  /// Currently displayed key set.
  private var keySet: KeySet!
  /// Gesture recognizer for keys
  private var gestureRecognizer: KeyGestureRecognizer!
  /// Current state of the shift key
  private var shiftKeyState: Key.State = .off
  /// Current state of the alt key
  private var altKeyState: Key.State = .off
  
  
  // MARK: Configuration
  
  func configure(keySet: KeySet, view: KeypadView) {
    self.keySet = keySet
    gestureRecognizer = KeyGestureRecognizer(delegate: self)
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  
  // MARK: Modifiers
  
  /**
   Operations to perform after a letter was tapped.
   */
  private func letterWasTapped() {
    if shiftKeyState == .on {
      tapShift()
    }
    if altKeyState == .on {
      tapAlt()
    }
  }
  
  private func tapShift() {
    shiftKeyState.toggle()
    Logger.debug("Shift key is now \(shiftKeyState).")
    delegate?.shiftStateChanged(newState: shiftKeyState)
  }
  
  private func tapAlt() {
    altKeyState.toggle()
    Logger.debug("Alt key is now \(altKeyState).")
    delegate?.altStateChanged(newState: altKeyState)
  }
  
  
  // MARK: Delegate communication
  
  private func tapLetter(at keyCoordinate: KeyCoordinate) {
    let key = keySet.key(at: keyCoordinate)
    delegate?.insert(text: key.set.letter(forShiftState: shiftKeyState, andAltState: altKeyState))
    letterWasTapped()
  }
  
  private func tapReturn() {
    delegate?.insert(text: "\n")
  }
  
  private func tapSpace() {
    delegate?.insert(text: " ")
  }
  
  private func tapDelete() {
    delegate?.deleteBackward()
  }
  
}


// MARK: - KeyGestureRecognizerDelegate

extension KeyState: KeyGestureRecognizerDelegate {
  
  func touchUp(at keypadCoordinate: KeypadCoordinate) {
    switch KeyLocator.kind(at: keypadCoordinate) {
    case .letter:
      let keyCoordinate = KeyCoordinate(row: keypadCoordinate.row, col: keypadCoordinate.col / 2)
      tapLetter(at: keyCoordinate)
    case .space:
      tapSpace()
    case .shift:
      tapShift()
    case .alt:
      tapAlt()
    case .delete:
      tapDelete()
    case .enter:
      tapReturn()
    case .next:
      delegate?.nextKeyboard()
    }
  }
  
}
