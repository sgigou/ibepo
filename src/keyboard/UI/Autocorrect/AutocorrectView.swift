//
//  AutocorrectView.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - AutocorrectView

/// Displays autocorrect suggestions and allow to select one.
final class AutocorrectView: UIView {
  
  // MARK: Life cycle
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    heightAnchor.constraint(equalToConstant: 40.0).isActive = true
  }
  
}
