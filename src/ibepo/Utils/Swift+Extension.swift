//
//  Swift+Extension.swift
//  ibepo
//
//  Created by Steve Gigou on 28/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation

// MARK: - Bool

extension Bool {

  /// XOR operator
  static func ^ (left: Bool, right: Bool) -> Bool {
    return left != right
  }

}
