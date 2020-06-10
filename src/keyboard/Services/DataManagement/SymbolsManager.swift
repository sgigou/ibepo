//
//  SymbolsManager.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-06.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

final class SymbolsManager {
  
  static func getImage(named name: String) -> UIImage {
    if #available(iOS 13, *) {
      return UIImage(systemName: name) ?? UIImage()
    } else {
      return UIImage(named: name) ?? UIImage()
    }
  }
  
}
