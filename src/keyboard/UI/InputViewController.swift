//
//  InputViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit
import os.log


// MARK: - InputViewController

/// Full keyboard view
final class InputViewController: UIViewController {
  
  weak var delegate: KeyboardActionProtocol?
  weak var switchDelegate: KeyboardSwitchProtocol?
  
  private var autocorrectViewController: AutocorrectViewController!
  private var keypadViewController: KeypadViewController!
  private var keypadHeightConstraint: NSLayoutConstraint!
  private var autocorrectHeightConstraint: NSLayoutConstraint!
  private var textModifiers: TextModifierSet!
  
  private var rowHeight: CGFloat {
    if UIDevice.isPhone {
      if UIScreen.isPortrait {
        return 50.0
      } else {
        return 40.0
      }
    } else {
      if UIScreen.isPortrait {
        return 70.0
      } else {
        return 70.0
      }
    }
  }
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateColorAppearance()
    loadViews()
    textModifiers = TextModifiersFactory.generate(for: self)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateColorAppearance()
  }
  
  // MARK: Configuration

  func textDidChange(_ textDocumentProxy: UITextDocumentProxy) {
    KeyboardSettings.shared.update(textDocumentProxy)
    autocorrectViewController.autocorrectEngine.update()
    textModifiers.moveOccured()
    keypadViewController.textDocumentProxyWasUpdated()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    updateHeights()
  }
  
  private func updateColorAppearance() {
    if #available(iOS 12.0, *) {
      switch traitCollection.userInterfaceStyle {
      case .light:
        ColorManager.shared.systemAppearance = .light
      case .dark:
        ColorManager.shared.systemAppearance = .dark
      default:
        ColorManager.shared.systemAppearance = .unspecified
      }
    } else {
      ColorManager.shared.systemAppearance = .unspecified
    }
  }
  
  // MARK: Loading
  
  private func loadViews() {
    loadKeypadView()
    loadSuggestionsView()
  }
  
  private func loadKeypadView() {
    keypadViewController = KeypadViewController()
    keypadViewController.delegate = self
    keypadViewController.switchDelegate = self
    add(keypadViewController, with: [
      keypadViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      keypadViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      keypadViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
    ])
    keypadHeightConstraint = NSLayoutConstraint(item: keypadViewController.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: rowHeight * 4)
    keypadHeightConstraint.isActive = true
    keypadViewController.view.layer.zPosition = 10.0
  }
  
  private func loadSuggestionsView() {
    autocorrectViewController = AutocorrectViewController()
    autocorrectViewController.delegate = self
    add(autocorrectViewController, with: [
      autocorrectViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      autocorrectViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      autocorrectViewController.view.bottomAnchor.constraint(equalTo: keypadViewController.view.topAnchor),
      autocorrectViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
    ])
    autocorrectHeightConstraint = NSLayoutConstraint(item: autocorrectViewController.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: rowHeight)
    autocorrectHeightConstraint.isActive = true
  }
  
  private func updateHeights() {
    autocorrectHeightConstraint.constant = rowHeight
    keypadHeightConstraint.constant = rowHeight * 4
  }
  
}


// MARK: - KeyboardActionProtocol

extension InputViewController: KeyboardActionProtocol {
  
  func insert(text: String) {
    if let replacement = autocorrectViewController.autocorrectEngine.correction(for: text) {
      replace(charactersAmount: KeyboardSettings.shared.textDocumentProxyAnalyzer.currentWord.count, by: replacement, separator: text)
    } else {
      delegate?.insert(text: text)
      autocorrectViewController.autocorrectEngine.update()
      textModifiers.modify()
    }
  }
  
  func replace(charactersAmount: Int, by text: String, separator: String) {
    delegate?.deleteBackward(amount: charactersAmount)
    delegate?.insert(text: text)
    if separator != "\n" {
      delegate?.insert(text: separator)
      autocorrectViewController.autocorrectEngine.update()
      textModifiers.modify()
    } else {
      // To allow the text input to take in account the return key, it should be given separately from the replaced text.
      // BUT, in some apps like reminders or first word of notes, textDidChange may be called after the following dispatch, but with the old context.
      // So, only for return key, wait for the event to dispatch before applying it.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
        [weak self] in
        self?.delegate?.insert(text: separator)
        self?.autocorrectViewController.autocorrectEngine.update()
        self?.textModifiers.modify()
        self?.keypadViewController.textDocumentProxyWasUpdated()
      }
    }
  }
  
  func deleteBackward() {
    delegate?.deleteBackward()
    autocorrectViewController.autocorrectEngine.update()
    textModifiers.deletionOccured()
  }
  
  func deleteBackward(amount: Int) {
    if amount == 0 { return }
    delegate?.deleteBackward(amount: amount)
    autocorrectViewController.autocorrectEngine.update()
    textModifiers.deletionOccured()
  }
  
  func nextKeyboard() {
    delegate?.nextKeyboard()
  }
  
  func moveCursor(by offset: Int) {
    delegate?.moveCursor(by: offset)
  }
  
}

// MARK: - KeyboardSwitchProtocol

extension InputViewController: KeyboardSwitchProtocol {

  func switchKeyAdded(_ switchButton: UIView) {
    switchDelegate?.switchKeyAdded(switchButton)
  }

}
