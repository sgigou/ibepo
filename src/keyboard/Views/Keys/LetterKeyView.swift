//
//  LetterKeyView.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// The display of a CharacterSet
final class LetterKeyView: KeyView {
  
  /// Level of the key. Will change its display on the keypad.
  enum Level {
    case primary, secondary
  }
  
  var primaryLabel = UILabel()
  var secondaryLabel = UILabel()
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initKey()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configuration
  
  func setLetters(primary: String, secondary: String) {
    primaryLabel.text = primary
    secondaryLabel.text = secondary
  }
  
  // MARK: Drawing
  
  func initKey() {
    initPrimaryLabel()
    initSecondaryLabel()
  }
  
  private func initSecondaryLabel() {
    guard let backgroundView = self.backgroundView else { return }
    secondaryLabel.font = .systemFont(ofSize: 12.0, weight: .light)
    secondaryLabel.textColor = ColorManager.secondaryLabel
    secondaryLabel.textAlignment = .center
    secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(secondaryLabel)
    NSLayoutConstraint.activate([
      secondaryLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 2),
      secondaryLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
      secondaryLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
      secondaryLabel.bottomAnchor.constraint(equalTo: primaryLabel.topAnchor),
    ])
  }
  
  private func initPrimaryLabel() {
    guard let backgroundView = self.backgroundView else { return }
    primaryLabel.font = .systemFont(ofSize: 20.0)
    primaryLabel.textColor = ColorManager.label
    primaryLabel.textAlignment = .center
    primaryLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(primaryLabel)
    NSLayoutConstraint.activate([
      primaryLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
      primaryLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -2),
      primaryLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
    ])
  }
  
}
