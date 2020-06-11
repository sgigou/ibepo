//
//  HomeViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - HomeViewController

class HomeViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  @IBAction func settingsTap() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.openURL(settingsUrl)
    }
  }
  
}


// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
