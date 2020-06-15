//
//  PageViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-15.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
  
  // MARK: Actions
  
  @IBAction func onSettingsTap() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.openURL(settingsUrl)
    }
  }

}
