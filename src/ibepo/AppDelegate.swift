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

  func applicationDidEnterBackground(_ application: UIApplication) {
    UniversalLogger.debug("applicationDidEnterBackground")
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      if let editorController = topController as? EditorViewController {
        editorController.persist()
      }
    }
  }

}

