//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeyboardViewController

/// View for custom keyboard extension
class KeyboardViewController: UIInputViewController {
  
  /// Full input view controller with keyboard and suggestions.
  private var customInputViewController: InputViewController!
  
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    customInputViewController.update(textDocumentProxy: textDocumentProxy)
  }

}


// MARK: - InputViewControllerDelegate

extension KeyboardViewController: InputViewControllerDelegate {
  func insert(_ text: String) {
    textDocumentProxy.insertText(text)
  }
}
