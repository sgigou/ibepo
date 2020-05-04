//
//  Key.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// A key set and its representing view.
struct Key {
  
  /// List of characters the view should display.
  let set: CharacterSet
  
  /// View that will display the characters of the set.
  let view: KeyView
  
}
