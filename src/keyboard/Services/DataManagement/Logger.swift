//
//  Logger.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-07.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation

final class Logger {
  
  static func debug(_ message: String) {
    printIfDebug(tag: "DEBUG", message: message)
  }
  
  static func error(_ message: String) {
    printIfDebug(tag: "ERROR", message: message)
  }
  
  private static func printIfDebug(tag: String, message: String) {
    #if DEBUG
      print("[\(tag)] \(message)")
    #endif
  }
  
}
