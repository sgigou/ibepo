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
  
  weak var actionDelegate: KeyboardActionProtocol?
  weak var displayDelegate: KeyboardDisplayProtocol?
  
  /// Currently displayed key set.
  private var keySet: KeySet!
  /// Gesture recognizer for keys
  private var gestureRecognizer: KeyGestureRecognizer!
  /// Current state of the shift key
  private var shiftKeyState: Key.State = .off
  /// Current state of the alt key
  private var altKeyState: Key.State = .off
  
  private var currentTouchBeginCoordinate: KeypadCoordinate?
  private var currentTouchCoordinate: KeypadCoordinate?
  
  
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
    displayDelegate?.shiftStateChanged(newState: shiftKeyState)
  }
  
  private func tapAlt() {
    altKeyState.toggle()
    Logger.debug("Alt key is now \(altKeyState).")
    displayDelegate?.altStateChanged(newState: altKeyState)
  }
  
  
  // MARK: Delegate communication
  
  private func tapLetter(at keyCoordinate: KeyCoordinate) {
    let key = keySet.key(at: keyCoordinate)
    actionDelegate?.insert(text: key.set.letter(forShiftState: shiftKeyState, andAltState: altKeyState))
    letterWasTapped()
  }
  
  private func tapReturn() {
    actionDelegate?.insert(text: "\n")
  }
  
  private func tapSpace() {
    actionDelegate?.insert(text: " ")
  }
  
  private func tapDelete() {
    actionDelegate?.deleteBackward()
  }
  
}


// MARK: - KeyGestureRecognizerDelegate

extension KeyState: KeyGestureRecognizerDelegate {
  
  func touchDown(at keypadCoordinate: KeypadCoordinate) {
    let kind = KeyLocator.kind(at: keypadCoordinate)
    currentTouchBeginCoordinate = keypadCoordinate
    currentTouchCoordinate = keypadCoordinate
    Logger.debug("Touch began at \(keypadCoordinate) (\(kind)")
    switch kind {
    case .letter:
      displayDelegate?.keyWasPressed(kind: kind, at: calculateKeyCoordinate(for: keypadCoordinate))
    default:
      displayDelegate?.keyWasPressed(kind: kind, at: nil)
    }
  }
  
  func touchMoved(to keypadCoordinate: KeypadCoordinate) {
    if currentTouchCoordinate != nil && currentTouchCoordinate! == keypadCoordinate {
      return
    }
    Logger.debug("Touch moved from \(currentTouchCoordinate.debugDescription) to \(keypadCoordinate).")
    guard let currentTouchBeginCoordinate = self.currentTouchBeginCoordinate else {
      return Logger.error("currentTouchBeginCoordinate shourd not be nil")
    }
    let beginKind = KeyLocator.kind(at: currentTouchBeginCoordinate)
    let kind = KeyLocator.kind(at: keypadCoordinate)
    if beginKind == .letter && (kind != .letter && kind != .space) {
      Logger.debug("User cannot move from letter to modifier key.")
      return
    }
    currentTouchCoordinate = keypadCoordinate
  }
  
  func touchUp(at keypadCoordinate: KeypadCoordinate) {
    Logger.debug("Touch ended at \(keypadCoordinate). Using \(currentTouchCoordinate.debugDescription).")
    let finalCoordinate = currentTouchCoordinate ?? keypadCoordinate
    switch KeyLocator.kind(at: finalCoordinate) {
    case .letter:
      tapLetter(at: calculateKeyCoordinate(for: finalCoordinate))
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
      actionDelegate?.nextKeyboard()
    }
    resetCurrentTouch()
  }
  
  func touchCancelled(at keypadCoordinate: KeypadCoordinate) {
    Logger.debug("Touch cancelled at \(keypadCoordinate).")
    resetCurrentTouch()
  }
  
  private func resetCurrentTouch() {
    currentTouchBeginCoordinate = nil
    currentTouchCoordinate = nil
  }
  
  private func calculateKeyCoordinate(for keypadCoordinate: KeypadCoordinate) -> KeyCoordinate {
    let col = keypadCoordinate.row == 2 ? (keypadCoordinate.col - 3) : keypadCoordinate.col
    let keyCoordinate = KeyCoordinate(row: keypadCoordinate.row, col: col / 2)
    return keyCoordinate
  }
  
}
