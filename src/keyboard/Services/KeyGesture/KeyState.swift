//
//  KeyState.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-07.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


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
  
  /// Toggle the shift status and tell the display delegate.
  private func tapShift() {
    shiftKeyState.toggle()
    Logger.debug("Shift key is now \(shiftKeyState).")
    displayDelegate?.shiftStateChanged(newState: shiftKeyState)
  }
  
  /// Toggle the alt status and tell the display delegate.
  private func tapAlt() {
    altKeyState.toggle()
    Logger.debug("Alt key is now \(altKeyState).")
    displayDelegate?.altStateChanged(newState: altKeyState)
  }
  
  /// Resets all current touch stored values and tells the delegate to reset pressed state.
  private func resetCurrentTouch() {
    currentTouchBeginCoordinate = nil
    currentTouchCoordinate = nil
    displayDelegate?.noKeyIsPressed()
  }
  
  /// Tells the display delegate that the key at the given coordinate is pressed.
  private func displayPressedKey(at keypadCoordinate: KeypadCoordinate) {
    let kind = KeyLocator.kind(at: keypadCoordinate)
    switch kind {
    case .letter:
      displayDelegate?.keyIsPressed(kind: kind, at: KeyLocator.calculateKeyCoordinate(for: keypadCoordinate))
    default:
      displayDelegate?.keyIsPressed(kind: kind, at: nil)
    }
  }
  
  /// Tells if the move from `beginKind` to `endKind` is allowed.
  /// 
  /// Touches can go from a modifier key to a letter, but not the other way.
  private func isMoveValid(beginKind: Key.Kind, endKind: Key.Kind) -> Bool {
    if !beginKind.isModifier && !endKind.isModifier {
      return true
    }
    return beginKind.isModifier && !endKind.isModifier
  }
  
  /// Resets the shift or alt status if the touch began on it.
  private func switchShiftAndAltAfterLetter() {
    if shiftKeyState == .on {
      tapShift()
    }
    if altKeyState == .on {
      tapAlt()
    }
  }
  
  
  // MARK: Delegate communication
  
  private func tapLetter(at keyCoordinate: KeyCoordinate) {
    let key = keySet.key(at: keyCoordinate)
    actionDelegate?.insert(text: key.set.letter(forShiftState: shiftKeyState, andAltState: altKeyState))
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
  
  func touchDown(at keypadCoordinate: KeypadCoordinate, with touch: UITouch) {
    let kind = KeyLocator.kind(at: keypadCoordinate)
    currentTouchBeginCoordinate = keypadCoordinate
    currentTouchCoordinate = keypadCoordinate
    switch kind {
    case .shift:
      tapShift()
    case .alt:
      tapAlt()
    default:
      break
    }
    displayPressedKey(at: keypadCoordinate)
  }
  
  func touchMoved(to keypadCoordinate: KeypadCoordinate, with touch: UITouch) {
    if currentTouchCoordinate != nil && currentTouchCoordinate! == keypadCoordinate {
      return
    }
    guard let currentTouchBeginCoordinate = self.currentTouchBeginCoordinate else {
      return Logger.error("currentTouchBeginCoordinate shourd not be nil")
    }
    let beginKind = KeyLocator.kind(at: currentTouchBeginCoordinate)
    let kind = KeyLocator.kind(at: keypadCoordinate)
    if !isMoveValid(beginKind: beginKind, endKind: kind) {
      return Logger.debug("User cannot move from \(beginKind) to \(kind).")
    }
    currentTouchCoordinate = keypadCoordinate
    displayPressedKey(at: keypadCoordinate)
  }
  
  func touchUp(at keypadCoordinate: KeypadCoordinate, with touch: UITouch) {
    let finalCoordinate = currentTouchCoordinate ?? keypadCoordinate
    let finalKind = KeyLocator.kind(at: finalCoordinate)
    switch finalKind {
    case .letter:
      tapLetter(at: KeyLocator.calculateKeyCoordinate(for: finalCoordinate))
    case .space:
      tapSpace()
    case .delete:
      tapDelete()
    case .enter:
      tapReturn()
    case .next:
      actionDelegate?.nextKeyboard()
    default:
      break
    }
    if !finalKind.isModifier { switchShiftAndAltAfterLetter() }
    resetCurrentTouch()
  }
  
}
