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
final class KeypadViewController: UIViewController {
  
  weak var delegate: KeyboardActionProtocol?
  weak var switchDelegate: KeyboardSwitchProtocol?
  
  private let keyboardState = KeyboardState()
  private let popupView = PopupView()
  
  private var keySet: KeySet!
  private var pressedKeyView: KeyView?
  
  // MARK: Life cycle
  
  override func loadView() {
    view = KeypadView()
    (view as! KeypadView).switchDelegate = self
    addPopupView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadKeySet()
    keyboardState.configure(keySet: keySet, view: view as! KeypadView)
    keyboardState.actionDelegate = self
    keyboardState.displayDelegate = self
    addObservers()
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
  
  @objc func keyboardAppearanceDidChange() {
    let view = self.view as! KeypadView
    view.updateAppearance()
    for row in keySet.rows {
      for key in row {
        key.view.updateAppearance()
      }
    }
    popupView.updateAppearance()
  }
  
  // MARK: Update
  
  func textDocumentProxyWasUpdated() {
    keyboardState.textDocumentProxyWasUpdated()
  }
  
  // MARK: Loading
  
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
  
  func keyIsPressed(kind: Key.Kind, at coordinate: KeyCoordinate?) {
    let keyViewToPress: KeyView
    switch kind {
    case .letter:
      guard let coordinate = coordinate else {
        return UniversalLogger.error("The key should have a coordinate.")
      }
      let key = keySet.key(at: coordinate)
      keyViewToPress = key.view
    default:
      guard let view = view as? KeypadView else {
        return UniversalLogger.error("The view should be a KeypadView.")
      }
      guard let keyView = view.view(for: kind) else {
        return UniversalLogger.error("Could not find key view")
      }
      keyViewToPress = keyView
    }
    if keyViewToPress != pressedKeyView {
      pressedKeyView?.togglePression()
      keyViewToPress.togglePression()
      if kind == .letter {
        guard let coordinate = coordinate else {
          return UniversalLogger.error("The key should have a coordinate.")
        }
        let key = keySet.key(at: coordinate)
        popupView.showPopup(for: key)
      } else {
        popupView.hidePopup()
      }
    }
    pressedKeyView = keyViewToPress
  }
  
  func noKeyIsPressed() {
    pressedKeyView?.togglePression()
    pressedKeyView = nil
    popupView.hidePopup()
  }
  
  func launchSubLetterSelection(for key: Key, shiftState: Key.State, altState: Key.State) {
    popupView.showPopupWithSubLetters(for: key, shiftState: shiftState, altState: altState)
  }
  
  func select(subLetter: String) {
    popupView.select(subLetter: subLetter)
  }
  
}

// MARK: - KeyboardSwitchProtocol

extension KeypadViewController: KeyboardSwitchProtocol {

  func switchKeyAdded(_ switchButton: UIView) {
    switchDelegate?.switchKeyAdded(switchButton)
  }

}
