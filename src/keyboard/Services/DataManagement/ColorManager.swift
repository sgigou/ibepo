//
//  ColorManager.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-06.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

final class ColorManager {
  
  enum ColorAppearance {
    case unspecified, light, dark
  }
  
  static let shared = ColorManager()
  
  var keyboardAppearance: ColorAppearance = .unspecified {
    didSet {
      if oldValue == keyboardAppearance { return }
      NotificationCenter.default.post(name: .keyboardAppearanceDidChange, object: nil)
    }
  }
  
  var systemAppearance: ColorAppearance = .unspecified {
    didSet {
      if oldValue == systemAppearance { return }
      NotificationCenter.default.post(name: .keyboardAppearanceDidChange, object: nil)
    }
  }
  
  var colorAppearance: ColorAppearance {
    if keyboardAppearance != .unspecified { return keyboardAppearance }
    if systemAppearance != .unspecified { return systemAppearance }
    return .unspecified
  }
  
  var mainColor: UIColor {
    if #available(iOS 13, *) {
      return .systemBlue
    } else {
      return colorAppearance == .dark ?
        UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0) :
        UIColor(red: 10.0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
  }
  
  var label: UIColor {
    if #available(iOS 13, *) {
      return .label
    } else {
      return colorAppearance == .dark ? .white : .black
    }
  }
  
  var secondaryLabel: UIColor {
    if #available(iOS 13, *) {
      return .secondaryLabel
    } else {
      return colorAppearance == .dark ?
        UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6) :
        UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    }
  }
  
  var background: UIColor {
    if colorAppearance == .dark {
      return UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    } else {
      return .white
    }
  }
  
  var secondaryBackground: UIColor {
    if colorAppearance == .dark {
      return UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1.0)
    } else {
      return UIColor(red: 0.698, green: 0.714, blue: 0.761, alpha: 1.0)
    }
  }
  
}
