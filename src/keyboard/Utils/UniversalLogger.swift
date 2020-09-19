//
//  UniversalLogger.swift
//  ibepo
//
//  Created by Steve Gigou on 18/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation
import os.log

final class UniversalLogger {

  static func debug(_ message: String, file: String = #file) {
    if #available(iOS 14.0, *) {
      UpToDateLogger.debug(message, category: (file as NSString).lastPathComponent)
    } else {
      #if DEBUG
      print("[DEBUG] \(message)")
      #endif
    }
  }

  static func error(_ message: String, file: String = #file) {
    if #available(iOS 14, *) {
      UpToDateLogger.error(message, category: (file as NSString).lastPathComponent)
    } else {
      #if DEBUG
      print("[ERROR] \(message)")
      #endif
    }
  }

}

@available(iOS 14.0, *)
final class UpToDateLogger {

  static let shared = UpToDateLogger()

  private var loggers = [String: Logger]()

  private func getLogger(for category: String) -> Logger {
    if let logger = loggers[category] { return logger }
    let logger = Logger(subsystem: "com.novesoft.ibepo", category: category)
    loggers[category] = logger
    return logger
  }

  static func debug(_ message: String, category: String) {
    shared.getLogger(for: category).debug("\(message)")
  }

  static func error(_ message: String, category: String) {
    shared.getLogger(for: category).error("\(message)")
  }

}
