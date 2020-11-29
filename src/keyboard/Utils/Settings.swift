//
//  SettingsKeys.swift
//  ibepo
//
//  Created by Steve Gigou on 29/11/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation

struct Settings {

  static let suiteName = "group.F2M6RF7E9E.com.novesoft.ibepo"
  static let userDefaults = UserDefaults(suiteName: suiteName)

  enum Key: String {
    case shouldDisplaySecondaryLetter
  }

  static func set(_ key: Key, to value: Any?) {
    userDefaults?.setValue(value, forKey: key.rawValue)
  }

  static func get(for key: Key) -> Any? {
    userDefaults?.value(forKey: key.rawValue)
  }

}
