//
//  AppDelegate.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-04-30.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    // TODO: Replace stub with real home view controller
    let homeViewController = UIViewController()
    homeViewController.view.backgroundColor = UIColor.red
    window?.rootViewController = homeViewController
    window?.makeKeyAndVisible()
    return true
  }

}

