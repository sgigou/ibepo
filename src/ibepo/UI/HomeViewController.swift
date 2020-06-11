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
  
  @IBAction func websiteTap() {
    guard let websiteUrl = URL(string: "https://github.com/sgigou/ibepo") else {
      return
    }
    if UIApplication.shared.canOpenURL(websiteUrl) {
      UIApplication.shared.openURL(websiteUrl)
    }
  }
  
  @IBAction func twitterTap() {
    guard let websiteUrl = URL(string: "https://twitter.com/stevegigou") else {
      return
    }
    if UIApplication.shared.canOpenURL(websiteUrl) {
      UIApplication.shared.openURL(websiteUrl)
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
