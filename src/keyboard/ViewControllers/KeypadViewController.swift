//
//  KeypadViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeypadViewController

/// Key pad part of the input view.
class KeypadViewController: UIViewController {
  
  /// Delegate that will receive text updates.
  weak var delegate: KeyboardActionProtocol?
  
  /// Key state manager
  private let keyState = KeyState()
  
  /// Currently displayed key set.
  private var keySet: KeySet!

  
  // MARK: Life cycle
  
  override func loadView() {
    self.view = KeypadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addObservers()
    loadKeySet()
    keyState.configure(keySet: keySet, view: view as! KeypadView)
    keyState.delegate = self
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: Notifications
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppearanceDidChange), name: .keyboardAppearanceDidChange, object: nil)
  }
  
  /**
   Update theme appearance.
   */
  @objc func keyboardAppearanceDidChange() {
    let view = self.view as! KeypadView
    view.updateAppearance()
    for row in keySet.rows {
      for key in row {
        key.view.updateAppearance()
      }
    }
  }
  
  
  // MARK: Loading
  
  /**
   Load the key set and display it in the KeypadView.
  */
  private func loadKeySet() {
    let view = self.view as! KeypadView
    let factory = KeySetFactory()
    keySet = factory.generate()
    view.load(keySet: keySet)
  }
  
}


// MARK: - KeyboardActionProtocol

extension KeypadViewController: KeyboardActionProtocol {
  
  func insert(text: String) {
    delegate?.insert(text: text)
  }
  
  func deleteBackward() {
    delegate?.deleteBackward()
  }
  
  func deleteBackward(amount: Int) {
    delegate?.deleteBackward(amount: amount)
  }
  
  func nextKeyboard() {
    delegate?.nextKeyboard()
  }
  
  func shiftStateChanged(newState: Key.State) {
    delegate?.shiftStateChanged(newState: newState)
    (view as? KeypadView)?.updateShiftState(newState)
    for key in keySet.keys {
      key.view.setLetters(
        primary: key.set.primaryLetter(forShiftState: newState),
        secondary: key.set.secondaryLetter(forShiftState: newState)
      )
    }
  }
  
  func altStateChanged(newState: Key.State) {
    delegate?.altStateChanged(newState: newState)
    (view as? KeypadView)?.updateAltState(newState)
  }
  
}
