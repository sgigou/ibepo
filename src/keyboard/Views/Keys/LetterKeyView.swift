//
//  LetterKeyView.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// The display of a CharacterSet
class LetterKeyView: KeyView {
  
  /// Level of the key. Will change its display on the keypad.
  enum Level {
    case primary, secondary
  }
  
  var primaryLabel = UILabel()
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initPrimaryLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Drawing
  
  func setLetters(primary: String) {
    primaryLabel.text = primary
  }
  
  private func initPrimaryLabel() {
    guard let backgroundView = self.backgroundView else { return }
    primaryLabel.textAlignment = .center
    primaryLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(primaryLabel)
    NSLayoutConstraint.activate([
      primaryLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor),
      primaryLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
      primaryLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
      primaryLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
    ])
  }
  
}
