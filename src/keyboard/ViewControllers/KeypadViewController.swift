//
//  KeypadViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

// MARK: - KeypadViewControllerDelegate

protocol KeypadViewControllerDelegate: class {
  func insertCharacter(_ character: String)
}


// MARK: - KeypadViewController

/// Key pad part of the input view.
class KeypadViewController: UIViewController {
  
  weak var delegate: KeypadViewControllerDelegate?
  
  /// Gesture recognizer for keys
  private var gestureRecognizer: KeyGestureRecognizer!
  /// Currently displayed key set.
  private var keySet: KeySet!

  
  // MARK: Life cycle
  
  override func loadView() {
    self.view = KeypadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadKeySet()
    gestureRecognizer = KeyGestureRecognizer(delegate: self)
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  
  // MARK: Loading
  
  /// Load the key set and display it in the KeypadView.
  private func loadKeySet() {
    let view = self.view as! KeypadView
    let factory = KeySetFactory()
    keySet = factory.generate()
    view.load(keySet: keySet)
  }
  
}


// MARK: - KeyGestureRecognizerDelegate

extension KeypadViewController: KeyGestureRecognizerDelegate {
  
  func letterTap(at coordinate: KeyCoordinate) {
    let key = keySet.key(at: coordinate)
    Logger.debug("Key was tapped: \(key)")
    delegate?.insertCharacter(key.set.primaryLetter)
  }
  
}
