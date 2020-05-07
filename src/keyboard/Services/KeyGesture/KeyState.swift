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
  
}


// MARK: - KeyGestureRecognizerDelegate

extension KeyState: KeyGestureRecognizerDelegate {
  
  func letterTap(at coordinate: KeyCoordinate) {
    let key = keySet.key(at: coordinate)
    Logger.debug("Key was tapped: \(key)")
    delegate?.insert(text: key.set.primaryLetter)
  }
  
}
