//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeyboardViewController

final class KeyboardViewController: UIInputViewController {
  
  private var customInputViewController: InputViewController!
  private var constraintsHaveBeenAdded = false
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.translatesAutoresizingMaskIntoConstraints = false
    initSettings()
    guard let inputView = inputView else { return }
    customInputViewController = InputViewController()
    customInputViewController.delegate = self
    add(customInputViewController, with: [
      customInputViewController.view.topAnchor.constraint(equalTo: inputView.topAnchor),
      customInputViewController.view.rightAnchor.constraint(equalTo: inputView.rightAnchor),
      customInputViewController.view.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
      customInputViewController.view.leftAnchor.constraint(equalTo: inputView.leftAnchor)
    ])
  }
  
  override func textDidChange(_ textInput: UITextInput?) {
    super.textDidChange(textInput)
    customInputViewController.textDidChange(textDocumentProxy)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    initKeyboardViewConstraints()
  }
  
  // MARK: Configuration
  
  private func initSettings() {
    if #available(iOSApplicationExtension 11.0, *) {
      UniversalLogger.debug("needsInputModeSwitchKey set to \(needsInputModeSwitchKey)")
      KeyboardSettings.shared.needsInputModeSwitchKey = needsInputModeSwitchKey
    }
  }
  
  private func initKeyboardViewConstraints() {
    if constraintsHaveBeenAdded { return }
    guard let superview = view.superview else { return UniversalLogger.error("Keyboard has no superview.") }
    view.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    view.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    constraintsHaveBeenAdded = true
  }

}

// MARK: - KeyboardActionProtocol

extension KeyboardViewController: KeyboardActionProtocol {
  
  func insert(text: String) {
    textDocumentProxy.insertText(text)
  }
  
  func deleteBackward() {
    textDocumentProxy.deleteBackward()
  }
  
  func deleteBackward(amount: Int) {
    for _ in 1...amount {
      deleteBackward()
    }
  }
  
  func nextKeyboard() {
    advanceToNextInputMode()
  }
  
  func moveCursor(by offset: Int) {
    textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
  }
  
}
