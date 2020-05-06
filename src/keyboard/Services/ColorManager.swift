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
  
  static var label: UIColor {
    if #available(iOS 13.0, *) {
      return .label
    } else {
      return .black
    }
  }
  
  static var secondaryLabel: UIColor {
    if #available(iOS 13.0, *) {
      return .secondaryLabel
    } else {
      return .gray
    }
  }
  
}
