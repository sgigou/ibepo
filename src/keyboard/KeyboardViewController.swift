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
  private var switchButton: UIButton?
  private var switchKeyView: UIView?
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.translatesAutoresizingMaskIntoConstraints = false
    initSettings()
    guard let inputView = inputView else { return }
    customInputViewController = InputViewController()
    customInputViewController.delegate = self
    customInputViewController.switchDelegate = self
    add(customInputViewController, with: [
      customInputViewController.view.topAnchor.constraint(equalTo: inputView.topAnchor),
      customInputViewController.view.rightAnchor.constraint(equalTo: inputView.rightAnchor),
      customInputViewController.view.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
      customInputViewController.view.leftAnchor.constraint(equalTo: inputView.leftAnchor)
    ])
  }
  
  override func textDidChange(_ textInput: UITextInput?) {
    super.textDidChange(textInput)
    UniversalLogger.debug("textDidChange")
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
    if amount <= 0 { return }
    for _ in 1...amount {
      deleteBackward()
    }
  }

  func nextKeyboard() {
    // This function is only a fallback if the switch button is not present.
    UniversalLogger.error("nextKeyboard should not be called.")
    advanceToNextInputMode()
  }
  
  func moveCursor(by offset: Int) {
    textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
  }
  
}

// MARK: - KeyboardSwitchProtocol

extension KeyboardViewController: KeyboardSwitchProtocol {

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard switchButton != nil else { return }
    // Hack to update frame after transition animations.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      [weak self] in
      self?.updateSwitchButtonFrame()
    }
  }

  func switchKeyAdded(_ switchKeyView: UIView) {
    self.switchKeyView = switchKeyView
    if switchButton?.superview == nil {
      UniversalLogger.debug("Adding switch button overlay")
      switchButton = UIButton()
      if #available(iOSApplicationExtension 10.0, *) {
        switchButton!.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
      } else {
        switchButton!.addTarget(self, action: #selector(advanceToNextInputMode), for: .touchUpInside)
      }
      view.addSubview(switchButton!)
    }
    updateSwitchButtonFrame()
  }

  private func updateSwitchButtonFrame() {
    guard let switchButton = self.switchButton else { return }
    view.bringSubviewToFront(switchButton)
    guard let keyFrame = switchKeyView?.frame else { return }
    let newFrame = CGRect(x: keyFrame.minX, y: view.frame.maxY - keyFrame.height, width: keyFrame.width, height: keyFrame.height)
    switchButton.frame = newFrame
  }

}
