//
//  ColorManager.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-06.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// Create keyboard colors based on current theme and iOS version.
final class ColorManager {
  
  /// Default instance of the ColorManager.
  static let shared = ColorManager()
  
  /// Current appearence of the keyboard.
  var keyboardAppearance: UIKeyboardAppearance = .default
  
  var label: UIColor {
    if #available(iOS 13, *) {
      return .label
    } else {
      return keyboardAppearance == .dark ? .white : .black
    }
  }
  
  var secondaryLabel: UIColor {
    if #available(iOS 13, *) {
      return .secondaryLabel
    } else {
      return keyboardAppearance == .dark ?
        UIColor(red: 235.0, green: 235.0, blue: 245.0, alpha: 0.6) :
        UIColor(red: 60.0, green: 60.0, blue: 67.0, alpha: 0.6)
    }
  }
  
  var background: UIColor {
    return keyboardAppearance == .dark ?
      UIColor(red: 0.424, green: 0.424, blue: 0.424, alpha: 1.0) :
      .white
  }
  
  var secondaryBackground: UIColor {
    return keyboardAppearance == .dark ?
      UIColor(red: 0.286, green: 0.286, blue: 0.286, alpha: 1.0) :
      UIColor(red: 0.698, green: 0.714, blue: 0.761, alpha: 1.0)
  }
  
}
