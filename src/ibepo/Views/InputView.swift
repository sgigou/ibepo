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
    loadViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    loadViews()
  }
  
  // Loading
  
  /// Load the key pad and the autocomplete view (if needed).
  private func loadViews() {
    let keyboardView = KeyboardView()
    addSubview(keyboardView)
    keyboardView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      keyboardView.leftAnchor.constraint(equalTo: leftAnchor),
      keyboardView.topAnchor.constraint(equalTo: topAnchor),
      keyboardView.rightAnchor.constraint(equalTo: rightAnchor),
      keyboardView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
}
