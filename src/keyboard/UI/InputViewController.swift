//
//  InputViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - InputViewController

/// Full keyboard view
final class InputViewController: UIViewController {
  
  /// Delegate that will get text CRUD.
  weak var delegate: KeyboardActionProtocol?
  
  /// The actual keyboard.
  private var keypadViewController: KeypadViewController!
  /// The autocorrect zone.
  private var autocorrectViewController: AutocorrectViewController!
  
  private var rowHeight: CGFloat {
    return 50.0
  }
  
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadViews()
  }
  
  
  // MARK: Configuration
  
  /**
   Refresh document proxy values.
   */
  func update(textDocumentProxy: UITextDocumentProxy) {
    KeyboardSettings.shared.update(textDocumentProxy)
    autocorrectViewController.autocorrect.update()
  }
  
  
  // MARK: Loading
  
  /**
   Load the key pad and the autocomplete view (if needed).
   */
  private func loadViews() {
    keypadViewController = KeypadViewController()
    keypadViewController.delegate = self
    add(keypadViewController!, with: [
      keypadViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      keypadViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      keypadViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      keypadViewController.view.heightAnchor.constraint(equalToConstant: rowHeight * 4)
    ])
    autocorrectViewController = AutocorrectViewController()
    autocorrectViewController.delegate = self
    add(autocorrectViewController, with: [
      autocorrectViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      autocorrectViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      autocorrectViewController.view.bottomAnchor.constraint(equalTo: keypadViewController.view.topAnchor),
      autocorrectViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      autocorrectViewController.view.heightAnchor.constraint(equalToConstant: rowHeight)
    ])
    keypadViewController.view.layer.zPosition = 10.0
  }
  
}


// MARK: - KeyboardActionProtocol

extension InputViewController: KeyboardActionProtocol {
  
  func insert(text: String) {
    if let replacement = autocorrectViewController.autocorrect.correction(for: text) {
      replace(charactersAmount: KeyboardSettings.shared.textDocumentProxyAnalyzer.currentWord.count, by: "\(replacement)")
    } else {
      delegate?.insert(text: text)
      autocorrectViewController.autocorrect.update()
    }
  }
  
  func replace(charactersAmount: Int, by text: String) {
    deleteBackward(amount: charactersAmount)
    delegate?.insert(text: text)
    autocorrectViewController.autocorrect.update()
  }
  
  func deleteBackward() {
    delegate?.deleteBackward()
    autocorrectViewController.autocorrect.update()
  }
  
  func deleteBackward(amount: Int) {
    if amount == 0 { return }
    delegate?.deleteBackward(amount: amount)
    autocorrectViewController.autocorrect.update()
  }
  
  func nextKeyboard() {
    delegate?.nextKeyboard()
  }
  
}
