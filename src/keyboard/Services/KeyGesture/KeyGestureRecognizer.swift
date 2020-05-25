//
//  KeyGestureRecognizer.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-07.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// Represents a tap on the keyboard. It has two times more columns than the KeySet.
typealias KeypadCoordinate = (row: Int, col: Int)

// MARK: - KeyGestureRecognizerDelegate

protocol KeyGestureRecognizerDelegate: class {
  func touchDown(at keypadCoordinate: KeypadCoordinate)
  func touchMoved(to keypadCoordinate: KeypadCoordinate)
  func touchUp(at keypadCoordinate: KeypadCoordinate)
  func touchCancelled(at keypadCoordinate: KeypadCoordinate)
}


// MARK: - KeyGestureRecognizer

/// Recognizer used to manage gestures in the app.
final class KeyGestureRecognizer: UIGestureRecognizer {
  
  /// Custom delegate allowing to manage more interactions with the gesture recognizer.
  private weak var customDelegate: KeyGestureRecognizerDelegate?
  
  /// Default coordinate to return in case of error.
  private let defaultCoordinate = KeyCoordinate(row: 0, col: 1)
  
  
  // MARK: Life cycle
  
  convenience init(delegate: KeyGestureRecognizerDelegate) {
    self.init()
    customDelegate = delegate
  }
  
  
  // MARK: Touches
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else {  return Logger.debug("No touch in recognizer") }
    let coordinate = findCoordinate(for: touch)
    customDelegate?.touchDown(at: coordinate)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    guard let touch = touches.first else {  return Logger.debug("No touch in recognizer") }
    let coordinate = findCoordinate(for: touch)
    customDelegate?.touchMoved(to: coordinate)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    guard let touch = touches.first else {  return Logger.debug("No touch in recognizer") }
    let coordinate = findCoordinate(for: touch)
    customDelegate?.touchUp(at: coordinate)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesCancelled(touches, with: event)
    guard let touch = touches.first else {  return Logger.debug("No touch in recognizer") }
    let coordinate = findCoordinate(for: touch)
    customDelegate?.touchCancelled(at: coordinate)
  }
  
  
  // MARK: Calculations
  
  /**
   Find the KeypadCoordinate of the given touch.
   */
  private func findCoordinate(for touch: UITouch) -> KeypadCoordinate {
    let row = findRow(for: touch)
    let col = findCol(for: touch, in: row)
    return KeypadCoordinate(row: row, col: col)
  }
  
  /**
   Find the row number for the given touch.
   */
  private func findRow(for touch: UITouch) -> Int {
    guard let view = self.view else {
      Logger.debug("Touch view not found.")
      return 3
    }
    let location = touch.location(in: view)
    return findPosition(location: location.y, size: view.frame.height, chunkAmount: 4)
  }
  
  /**
   Find the col number for the given touch, in the given row.
   */
  private func findCol(for touch: UITouch, in row: Int) -> Int {
    guard let view = self.view else {
      Logger.debug("Touch view not found.")
      return 0
    }
    let location = touch.location(in: view)
    return findPosition(location: location.x, size: view.frame.width, chunkAmount: 22)
  }
  
  /**
   Split the given `size` in `chunkAmount` chunks, and tells in which chunk `location` is.
   */
  private func findPosition(location: CGFloat, size: CGFloat, chunkAmount: Int) -> Int {
    let chunkSize = size / CGFloat(chunkAmount)
    let chunk = Int(location / chunkSize)
    return min (chunk, chunkAmount - 1)
  }
  
}
