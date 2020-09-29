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
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    UniversalLogger.debug("applicationWillResignActive")
    NotificationCenter.default.post(name: .applicationWillResignActive, object: nil)
  }

  func applicationWillTerminate(_ application: UIApplication) {
      UniversalLogger.debug("applicationWillTerminate")
      NotificationCenter.default.post(name: .applicationWillResignActive, object: nil)
  }

}

