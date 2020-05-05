//
//  HomeViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// Main app view controller
class HomeViewController: UIViewController {
  
  // TODO: Stub to help debugging
  override func viewDidLoad() {
    super.viewDidLoad()
    let keyboard = InputViewController()
    keyboard.view.backgroundColor = .lightGray
    if #available(iOS 13, *) {
      add(keyboard, with: [
        keyboard.view.leftAnchor.constraint(equalTo: view.leftAnchor),
        keyboard.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        keyboard.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      ])
    }
  }

}
