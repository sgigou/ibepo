//
//  InputViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// Full keyboard view
class InputViewController: UIViewController {
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBlue
    loadViews()
  }
  
  // Loading
  
  /// Load the key pad and the autocomplete view (if needed).
  private func loadViews() {
    let keypadViewController = KeypadViewController()
    add(keypadViewController, with: [
      keypadViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      keypadViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      keypadViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      keypadViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
    ])
  }
  
}
