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
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let inputView = inputView else { return }
    let inputViewController = InputViewController()
    inputViewController.delegate = self
    add(inputViewController, with: [
      inputViewController.view.topAnchor.constraint(equalTo: inputView.topAnchor),
      inputViewController.view.rightAnchor.constraint(equalTo: inputView.rightAnchor),
      inputViewController.view.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
      inputViewController.view.leftAnchor.constraint(equalTo: inputView.leftAnchor)
    ])
  }

}

// MARK: - InputViewControllerDelegate

extension KeyboardViewController: InputViewControllerDelegate {
  func insert(_ text: String) {
    textDocumentProxy.insertText(text)
  }
}
