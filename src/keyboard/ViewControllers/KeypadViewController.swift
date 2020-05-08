//
//  KeypadViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeypadViewControllerDelegate

/// Delegate protocol to reflect text CRUD operations.
protocol KeypadViewControllerDelegate: class {
  
  /// Text should be inserted.
  func insert(text: String)
  
}


// MARK: - KeypadViewController

/// Key pad part of the input view.
class KeypadViewController: UIViewController {
  
  /// Delegate that will receive text updates.
  weak var delegate: KeypadViewControllerDelegate?
  
  /// Key state manager
  private let keyState = KeyState()
  
  /// Currently displayed key set.
  private var keySet: KeySet!

  
  // MARK: Life cycle
  
  override func loadView() {
    self.view = KeypadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadKeySet()
    keyState.configure(keySet: keySet, view: view as! KeypadView)
    keyState.delegate = self
  }
  
  
  // MARK: Configuration
  
  /**
   Update theme appearance.
   */
  func updateAppearance() {
    let view = self.view as! KeypadView
    view.updateAppearance()
    for row in keySet.rows {
      for key in row {
        key.view.updateAppearance()
      }
    }
  }
  
  
  // MARK: Loading
  
  /**
   Load the key set and display it in the KeypadView.
  */
  private func loadKeySet() {
    let view = self.view as! KeypadView
    let factory = KeySetFactory()
    keySet = factory.generate()
    view.load(keySet: keySet)
  }
  
}


// MARK: - KeyStateDelegate

extension KeypadViewController: KeyStateDelegate {
  
  func insert(text: String) {
    delegate?.insert(text: text)
  }
  
}
