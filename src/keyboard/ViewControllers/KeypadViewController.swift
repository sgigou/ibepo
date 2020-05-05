//
//  KeypadViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// Key pad part of the input view.
class KeypadViewController: UIViewController {
  
  private var keySet: KeySet!
  
  // MARK: Life cycle
  
  override func loadView() {
    let view = KeypadView()
    view.initRowStack()
    view.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadKeySet()
  }
  
  // MARK: Loading
  
  private func loadKeySet() {
    let view = self.view as! KeypadView
    let factory = KeySetFactory()
    keySet = factory.generate()
    view.add(keySet: keySet)
  }
  
}
