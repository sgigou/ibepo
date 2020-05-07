//
//  Logger.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-07.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation

/// Lightweight logger to print only in DEBUG.
class Logger {
  
  static func debug(_ message: String) {
    #if DEBUG
      print("[DEBUG] \(message)")
    #endif
  }
  
}
