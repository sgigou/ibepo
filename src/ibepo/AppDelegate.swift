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
  
  // MARK: Life cycle

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let homeViewController = generateHomeViewController()
    window?.rootViewController = homeViewController
    window?.makeKeyAndVisible()
    return true
  }
  
  // MARK: Home screen init
  
  private func generateHomeViewController() -> UIViewController {
    let navigationViewController = UINavigationController()
    let homeViewController = HomeViewController()
    navigationViewController.pushViewController(homeViewController, animated: false)
    return navigationViewController
  }

}

