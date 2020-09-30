//
//  InstallViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 25/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

class InstallViewController: UIViewController {

  @IBAction func onSettingsTap() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.openURL(settingsUrl)
    }
  }

}
