//
//  InputView.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-02.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// Full keyboard view
@IBDesignable
class InputView: UIView {
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    // TODO: Stub
    backgroundColor = .systemBlue
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    backgroundColor = .systemBlue
  }
  
}
