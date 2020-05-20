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
    autocorrectViewController.update()
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
    ])
    autocorrectViewController = AutocorrectViewController()
    add(autocorrectViewController, with: [
      autocorrectViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      autocorrectViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      autocorrectViewController.view.bottomAnchor.constraint(equalTo: keypadViewController.view.topAnchor),
      autocorrectViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
    ])
  }
  
}


// MARK: - KeyboardActionProtocol

extension InputViewController: KeyboardActionProtocol {
  
  func insert(text: String) {
    delegate?.insert(text: text)
    autocorrectViewController.update(text)
  }
  
  func deleteBackward() {
    delegate?.deleteBackward()
    autocorrectViewController.update()
  }
  
  func deleteBackward(amount: Int) {
    delegate?.deleteBackward(amount: amount)
    autocorrectViewController.update()
  }
  
  func nextKeyboard() {
    delegate?.nextKeyboard()
  }
  
}
