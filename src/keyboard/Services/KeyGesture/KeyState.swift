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
  
  enum Mode {
    case writing, selectingSubLetter
  }
  
  weak var actionDelegate: KeyboardActionProtocol?
  weak var displayDelegate: KeyboardDisplayProtocol?
  
  private var keySet: KeySet!
  private var currentMode: Mode = .writing

  private var gestureRecognizer: KeyGestureRecognizer!
  private var shiftState: Key.State = .off
  private var altState: Key.State = .off
  private var writingTouch: Touch?
  private var modifierTouch: Touch?
  
  private var longPressTimer: Timer?
  private var subLetterOriginKeyCoordinate: KeyCoordinate?
  private var currentSubLetter = ""
  
  // MARK: Configuration
  
  func configure(keySet: KeySet, view: KeypadView) {
    self.keySet = keySet
    gestureRecognizer = KeyGestureRecognizer(delegate: self)
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  
  // MARK: Modifiers
  
  private func tapShift() {
    shiftState.toggle()
    Logger.debug("Shift key is now \(shiftState).")
    displayDelegate?.shiftStateChanged(newState: shiftState)
  }
  
  private func tapAlt() {
    altState.toggle()
    Logger.debug("Alt key is now \(altState).")
    displayDelegate?.altStateChanged(newState: altState)
  }
  
  private func resetWritingTouch() {
    writingTouch = nil
    currentMode = .writing
    subLetterOriginKeyCoordinate = nil
    currentSubLetter = ""
    displayDelegate?.noKeyIsPressed()
  }
  
  private func displayPressedKey(at keypadCoordinate: KeypadCoordinate) {
    let kind = KeyLocator.kind(at: keypadCoordinate)
    switch kind {
    case .letter:
      displayDelegate?.keyIsPressed(kind: kind, at: KeyLocator.calculateKeyCoordinate(for: keypadCoordinate))
    default:
      displayDelegate?.keyIsPressed(kind: kind, at: nil)
    }
  }
  
  private func isMoveValid(beginKind: Key.Kind, endKind: Key.Kind) -> Bool {
    if !beginKind.isModifier && !endKind.isModifier {
      return true
    }
    return beginKind.isModifier && !endKind.isModifier
  }
  
  /// Resets the shift or alt status if the touch began on it.
  private func switchShiftAndAltAfterLetter() {
    if modifierTouch != nil { return }
    if shiftState == .on {
      tapShift()
    }
    if altState == .on {
      tapAlt()
    }
  }
  
  private func writeCurrentLetter() {
    guard let writingTouch = self.writingTouch else { return }
    switch currentMode {
    case .selectingSubLetter:
      actionDelegate?.insert(text: currentSubLetter)
    default:
      tapLetter(at: KeyLocator.calculateKeyCoordinate(for: writingTouch.currentCoordinate))
    }
  }
  
  // MARK: Long press
  
  private func invalidateLongPressTimer() {
    if longPressTimer != nil {
      longPressTimer!.invalidate()
    }
  }
  
  private func launchLongPressTimer() {
    invalidateLongPressTimer()
    longPressTimer = Timer(timeInterval: Constants.longPressDelay, target: self, selector: #selector(activateLongPress), userInfo: nil, repeats: false)
    longPressTimer?.tolerance = 0.100
    RunLoop.current.add(longPressTimer!, forMode: .common)
  }
  
  @objc private func activateLongPress() {
    guard let writingTouch = self.writingTouch else { return }
    switch KeyLocator.kind(at: writingTouch.currentCoordinate) {
    case .letter:
      launchSubSymbolSelection()
    default:
      break
    }
  }
  
  private func launchSubSymbolSelection() {
    guard let writingTouch = self.writingTouch else { return }
    let keyCoordinate = KeyLocator.calculateKeyCoordinate(for: writingTouch.currentCoordinate)
    let key = keySet.key(at: keyCoordinate)
    if key.set.subLetters(forShiftState: shiftState, andAltState: altState).count <= 1 { return }
    Logger.debug("Launching sub letter selection.")
    currentMode = .selectingSubLetter
    subLetterOriginKeyCoordinate = keyCoordinate
    currentSubLetter = key.set.letter(forShiftState: shiftState, andAltState: altState)
    displayDelegate?.launchSubLetterSelection(for: key, shiftState: shiftState, altState: altState)
  }
  
  private func moveSubLetterSelection(to keypadCoordinate: KeypadCoordinate) {
    if shouldCancelSubSelection(for: keypadCoordinate) {
      resetWritingTouch()
    }
    guard let subLetterOriginKeyCoordinate = self.subLetterOriginKeyCoordinate else { return }
    let originKey = keySet.key(at: subLetterOriginKeyCoordinate)
    let selectedShift = calculateSubLetterShift(for: keypadCoordinate)
    let mainLetter = originKey.set.letter(forShiftState: shiftState, andAltState: altState)
    let subLetters = originKey.set.subLetters(forShiftState: shiftState, andAltState: altState)
    let mainLetterIndex = subLetters.firstIndex(of: mainLetter) ?? 0
    var selectedIndex = mainLetterIndex + selectedShift
    selectedIndex = max(0, selectedIndex)
    selectedIndex = min(subLetters.count - 1, selectedIndex)
    currentSubLetter = subLetters[safe: selectedIndex] ?? mainLetter
    displayDelegate?.select(subLetter: currentSubLetter)
  }
  
  private func calculateSubLetterShift(for keypadCoordinate: KeypadCoordinate) -> Int {
    guard let originCoordinate = subLetterOriginKeyCoordinate else { return 0 }
    let keyCoordinate = KeyLocator.calculateKeyCoordinate(for: keypadCoordinate)
    return keyCoordinate.col - originCoordinate.col
  }
  
  private func shouldCancelSubSelection(for newKeypadCoordinate: KeypadCoordinate) -> Bool {
    guard let subLetterOriginKeyCoordinate = self.subLetterOriginKeyCoordinate else { return true }
    return newKeypadCoordinate.row != subLetterOriginKeyCoordinate.row && newKeypadCoordinate.row != subLetterOriginKeyCoordinate.row - 1
  }
  
  // MARK: Delegate communication
  
  private func tapLetter(at keyCoordinate: KeyCoordinate) {
    let key = keySet.key(at: keyCoordinate)
    actionDelegate?.insert(text: key.set.letter(forShiftState: shiftState, andAltState: altState))
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
    if currentMode == .selectingSubLetter {
      return moveSubLetterSelection(to: keypadCoordinate)
    }
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
    invalidateLongPressTimer()
    guard let writingTouch = self.writingTouch else { return }
    if touch != writingTouch.touch { return }
    switch writingTouch.currentKind {
    case .letter:
      writeCurrentLetter()
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
    resetWritingTouch()
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
