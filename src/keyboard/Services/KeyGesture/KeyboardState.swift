//
//  KeyboardState.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-07.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeyboardState

final class KeyboardState {
  
  typealias LetterTapTimestamp = (kind: Key.Kind, date: Date)
  
  enum Mode {
    case writing, selectingSubLetter, deletionLoop
  }
  
  weak var actionDelegate: KeyboardActionProtocol?
  weak var displayDelegate: KeyboardDisplayProtocol?
  
  private let autoCapitalizer = AutoCapitalizer()
  
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
  
  private var deletionLoopTimer: Timer?
  
  private var lastTap: LetterTapTimestamp?
  
  // MARK: Configuration
  
  func configure(keySet: KeySet, view: KeypadView) {
    self.keySet = keySet
    gestureRecognizer = KeyGestureRecognizer(delegate: self)
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  func textDocumentProxyWasUpdated() {
    readAutoCapitalization()
  }
    
  // MARK: Double-tap
  
  private func isDoubleTap(kind: Key.Kind) -> Bool {
    guard let lastTap = self.lastTap else { return false }
    return lastTap.kind == kind && Date().timeIntervalSince(lastTap.date) < Constants.doubleTapDelay
  }
  
  private func registerTap(on kind: Key.Kind) {
    lastTap = LetterTapTimestamp(kind: kind, date: Date())
  }
  
  // MARK: Modifiers
  
  private func tapShift() {
    if isDoubleTap(kind: .shift) {
      UniversalLogger.debug("Double tap on shift.")
      lastTap = nil
      shiftState = .locked
    } else {
      registerTap(on: .shift)
      shiftState.toggle()
    }
    displayDelegate?.shiftStateChanged(newState: shiftState)
  }
  
  private func tapAlt() {
    if isDoubleTap(kind: .alt) {
      UniversalLogger.debug("Double tap on alt.")
      lastTap = nil
      altState = .locked
    } else {
      if !altState.isActive { registerTap(on: .alt) }
      altState.toggle()
    }
    displayDelegate?.altStateChanged(newState: altState)
  }
  
  private func switchAltAfterLetter() {
    if modifierTouch != nil { return }
    if altState == .on {
      tapAlt()
    }
  }
  
  private func readAutoCapitalization() {
    if shiftState == .locked { return }
    if modifierTouch != nil { return }
    if autoCapitalizer.shouldCapitalize() != shiftState.isActive {
      shiftState.toggle()
      displayDelegate?.shiftStateChanged(newState: shiftState)
    }
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

  private func getCurrentLetter() -> String {
    guard let writingTouch = self.writingTouch else { return "" }
    switch currentMode {
    case .selectingSubLetter:
      return currentSubLetter
    default:
      let keyCoordinate = KeyLocator.calculateKeyCoordinate(for: writingTouch.currentCoordinate)
      let key = keySet.key(at: keyCoordinate)
      return key.set.letter(forShiftState: shiftState, andAltState: altState)
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
    case .delete:
      enterInDeletionLoop()
    default:
      break
    }
  }
  
  private func launchSubSymbolSelection() {
    guard let writingTouch = self.writingTouch else { return }
    let keyCoordinate = KeyLocator.calculateKeyCoordinate(for: writingTouch.currentCoordinate)
    let key = keySet.key(at: keyCoordinate)
    if key.set.subLetters(forShiftState: shiftState, andAltState: altState).count <= 1 { return }
    UniversalLogger.debug("Launching sub letter selection.")
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
  
  // MARK: Deletion
  
  private func enterInDeletionLoop() {
    currentMode = .deletionLoop
    deletionLoopTimer = Timer(timeInterval: Constants.deletionLoopDelay, target: self, selector: #selector(deletionLoop), userInfo: nil, repeats: true)
    RunLoop.current.add(deletionLoopTimer!, forMode: .common)
  }
  
  @objc private func deletionLoop() {
    tapDelete()
  }
  
  private func invalidateDeletionLoopTimer() {
    deletionLoopTimer?.invalidate()
    deletionLoopTimer = nil
  }
  
  // MARK: Delegate communication

  private func writeCurrentLetter() {
    let letter = getCurrentLetter()
    if ["'", "’"].contains(letter) {
      switchAltAfterLetter()
    }
    insert(letter)
  }
  
  private func tapReturn() {
    insert("\n")
  }
  
  private func tapSpace() {
    insert(" ")
  }
  
  private func tapDelete() {
    let shouldUppercase = (shiftState == .locked) ? true : autoCapitalizer.shouldCapitalizeAfterDeletion()
    actionDelegate?.deleteBackward()
    if shouldUppercase && !shiftState.isActive {
      shiftState = .on
      displayDelegate?.shiftStateChanged(newState: shiftState)
    } else {
      readAutoCapitalization()
    }
  }
  
  private func insert(_ text: String) {
    actionDelegate?.insert(text: text)
    readAutoCapitalization()
  }
  
}


// MARK: - KeyGestureRecognizerDelegate

extension KeyboardState: KeyGestureRecognizerDelegate {
  
  func touchDown(at keypadCoordinate: KeypadCoordinate, with touch: UITouch) {
    if let writingTouch = self.writingTouch {
      if currentMode == .deletionLoop { return }
      if writingTouch.beginKind.isModifier {
        modifierTouch = writingTouch
      } else {
        touchUp(at: writingTouch.currentCoordinate, with: writingTouch.touch)
      }
    }
    writingTouch = KeyboardState.Touch(touch: touch, coordinate: keypadCoordinate)
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
    if currentMode == .deletionLoop { return }
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
      switchAltAfterLetter()
      readAutoCapitalization()
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
      switchAltAfterLetter()
    case .delete:
      if currentMode == .deletionLoop {
        invalidateDeletionLoopTimer()
      } else {
        tapDelete()
      }
    case .enter:
      tapReturn()
    case .next:
      actionDelegate?.nextKeyboard()
    default:
      break
    }
    resetWritingTouch()
  }
  
}


// MARK: - KeyboardState.Touch

extension KeyboardState {
  
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
