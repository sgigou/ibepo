//
//  Notification.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation

extension Notification.Name {
  
  static let keyboardAppearanceDidChange = Notification.Name("keyboardAppearanceDidChange")
  static let returnKeyTypeDidChange = Notification.Name("returnKeyTypeDidChange")
  static let userSelectedASuggestion = Notification.Name("userSelectedASuggestion")
  
}
