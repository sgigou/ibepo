//
//  InputViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

// MARK: - InputViewControllerDelegate

protocol InputViewControllerDelegate: class {
  func insert(_ text: String)
}


// MARK: - InputViewController

/// Full keyboard view
class InputViewController: UIViewController {
  
  weak var delegate: InputViewControllerDelegate?
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadViews()
  }
  
  // Loading
  
  /// Load the key pad and the autocomplete view (if needed).
  private func loadViews() {
    let keypadViewController = KeypadViewController()
    keypadViewController.delegate = self
    add(keypadViewController, with: [
      keypadViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      keypadViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      keypadViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      keypadViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
    ])
  }
  
}

// MARK: - KeypadViewControllerDelegate

extension InputViewController: KeypadViewControllerDelegate {
  
  func insertCharacter(_ character: String) {
    delegate?.insert(character)
  }
  
}
