//
//  SymbolsManager.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-06.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// Generate SF Symbols, or text if not available.
final class SymbolsManager {
  
  /**
   Get the image for the given name.
   - parameter named: The name of the image. It must be an SF Symbols name.
   - returns: The asked image, as an SF Symbol image or as an SVG image. Returns an empty image if the key does not exist.
   */
  static func getImage(named name: String) -> UIImage {
    if #available(iOS 13, *) {
      return UIImage(systemName: name) ?? UIImage()
    } else {
      return UIImage(named: name) ?? UIImage()
    }
  }
  
}
