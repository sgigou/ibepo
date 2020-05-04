//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// View for custom keyboard extension
class KeyboardViewController: UIInputViewController {
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Temporary loading
    let keyboardView = InputView()
    guard let inputView = inputView else { return }
    inputView.addSubview(keyboardView)
    keyboardView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      keyboardView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
      keyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
      keyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
      keyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
      ])
  }

}
