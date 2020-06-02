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
  private let popupView = PopupView()
  
  /// Currently displayed key set.
  private var keySet: KeySet!
  /// The pressed key, if any
  private var pressedKeyView: KeyView?

  
  // MARK: Life cycle
  
  override func loadView() {
    view = KeypadView()
    addPopupView()
  }
  
  /// Loads the key set.
  override func viewDidLoad() {
    super.viewDidLoad()
    addObservers()
    loadKeySet()
    keyState.configure(keySet: keySet, view: view as! KeypadView)
    keyState.actionDelegate = self
    keyState.displayDelegate = self
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    for key in keySet.keys {
      key.view.updateAppearance()
    }
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
    view.bringSubviewToFront(popupView)
  }
  
  private func addPopupView() {
    popupView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(popupView)
    popupView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    popupView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    popupView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
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
  
}


// MARK: - KeyboardDisplayProtocol

extension KeypadViewController: KeyboardDisplayProtocol {
  
  func shiftStateChanged(newState: Key.State) {
    (view as? KeypadView)?.updateShiftState(newState)
    for key in keySet.keys {
      key.view.setLetters(
        primary: key.set.primaryLetter(forShiftState: newState),
        secondary: key.set.secondaryLetter(forShiftState: newState)
      )
    }
  }
  
  func altStateChanged(newState: Key.State) {
    (view as? KeypadView)?.updateAltState(newState)
    for key in keySet.keys {
      key.view.isAltActivated = newState.isActive
    }
  }
  
  /// Unpress the currently pressed key and press the given key
  func keyIsPressed(kind: Key.Kind, at coordinate: KeyCoordinate?) {
    let keyViewToPress: KeyView
    switch kind {
    case .letter:
      guard let coordinate = coordinate else {
        return Logger.error("The key should have a coordinate.")
      }
      let key = keySet.key(at: coordinate)
      keyViewToPress = key.view
    default:
      guard let view = view as? KeypadView else {
        return Logger.error("The view should be a KeypadView.")
      }
      guard let keyView = view.view(for: kind) else {
        return Logger.error("Could not find key view")
      }
      keyViewToPress = keyView
    }
    if keyViewToPress != pressedKeyView {
      pressedKeyView?.togglePression()
      keyViewToPress.togglePression()
      if kind == .letter {
        guard let coordinate = coordinate else {
          return Logger.error("The key should have a coordinate.")
        }
        let key = keySet.key(at: coordinate)
        popupView.showPopup(for: key)
      } else {
        popupView.hidePopup()
      }
    }
    pressedKeyView = keyViewToPress
  }
  
  /// Unpress the currently pressed view (if any).
  func noKeyIsPressed() {
    pressedKeyView?.togglePression()
    pressedKeyView = nil
    popupView.hidePopup()
  }
  
}
