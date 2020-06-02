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
  
  /// Touch that will output a letter.
  private var writingTouch: Touch?
  /// Touch that will keep a modifier on.
  private var modifierTouch: Touch?
  
  private var longPressTimer: Timer?
  
  
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
    writingTouch = nil
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
    if modifierTouch != nil { return }
    if shiftKeyState == .on {
      tapShift()
    }
    if altKeyState == .on {
      tapAlt()
    }
  }
  
  // MARK: Long press
  
  private func invalidateTimer() {
    if longPressTimer != nil {
      longPressTimer!.invalidate()
    }
  }
  
  private func launchLongPressTimer() {
    invalidateTimer()
    longPressTimer = Timer(timeInterval: 1.5, target: self, selector: #selector(activateLongPress), userInfo: nil, repeats: false)
    longPressTimer?.tolerance = 0.250
    RunLoop.current.add(longPressTimer!, forMode: .common)
  }
  
  @objc private func activateLongPress() {
    Logger.debug("Long press detected.")
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
    if let writingTouch = self.writingTouch {
      if writingTouch.beginKind.isModifier {
        modifierTouch = writingTouch
      } else {
        touchUp(at: writingTouch.currentCoordinate, with: writingTouch.touch)
      }
    }
    writingTouch = KeyState.Touch(touch: touch, coordinate: keypadCoordinate)
    switch writingTouch!.beginKind {
    case .shift:
      tapShift()
    case .alt:
      tapAlt()
    default:
      break
    }
    displayPressedKey(at: keypadCoordinate)
    launchLongPressTimer()
  }
  
  func touchMoved(to keypadCoordinate: KeypadCoordinate, with touch: UITouch) {
    guard let writingTouch = self.writingTouch else { return }
    if touch != writingTouch.touch { return }
    if writingTouch.currentCoordinate == keypadCoordinate { return }
    let kind = KeyLocator.kind(at: keypadCoordinate)
    if !isMoveValid(beginKind: writingTouch.beginKind, endKind: kind) {
      return
    }
    if !KeyLocator.isSameKey(keypadCoordinate1: writingTouch.currentCoordinate, keypadCoordinate2: keypadCoordinate) {
      displayPressedKey(at: keypadCoordinate)
      launchLongPressTimer()
    }
    writingTouch.currentCoordinate = keypadCoordinate
  }
  
  func touchUp(at keypadCoordinate: KeypadCoordinate, with touch: UITouch) {
    if modifierTouch != nil && modifierTouch!.touch == touch {
      modifierTouch = nil
      switchShiftAndAltAfterLetter()
      return
    }
    invalidateTimer()
    guard let writingTouch = self.writingTouch else { return }
    if touch != writingTouch.touch { return }
    switch writingTouch.currentKind {
    case .letter:
      tapLetter(at: KeyLocator.calculateKeyCoordinate(for: writingTouch.currentCoordinate))
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
    if !writingTouch.currentKind.isModifier { switchShiftAndAltAfterLetter() }
    resetCurrentTouch()
  }
  
}


// MARK: - KeyState.Touch

extension KeyState {
  
  class Touch {
    
    let touch: UITouch
    
    var beginCoordinate: KeypadCoordinate {
      didSet {
        beginKind = KeyLocator.kind(at: beginCoordinate)
      }
    }
    var currentCoordinate: KeypadCoordinate {
      didSet {
        currentKind = KeyLocator.kind(at: currentCoordinate)
      }
    }
    
    private(set) var beginKind: Key.Kind!
    private(set) var currentKind: Key.Kind!
    
    init(touch: UITouch, coordinate: KeypadCoordinate) {
      self.touch = touch
      self.beginCoordinate = coordinate
      self.currentCoordinate = coordinate
      // Defering the assignation to call didSet.
      defer {
        beginCoordinate = coordinate
        currentCoordinate = coordinate
      }
    }
  }
  
}
