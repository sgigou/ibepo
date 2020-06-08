//
//  AutoCapitalizer.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

class AutoCapitalizer {
  
  func shouldCapitalize() -> Bool {
    let type = KeyboardSettings.shared.autoCapitalizationType
    switch type {
    case .allCharacters:
      return true
    default:
      return false
    }
  }
  
}
