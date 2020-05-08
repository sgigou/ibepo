//
//  LetterKeyView.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - LetterKeyView

/// The display of a CharacterSet
final class LetterKeyView: KeyView {
  
  /// Level of the key. Will change its display on the keypad.
  enum Level {
    case primary, secondary
  }
  
  /// Label displaying the main letter.
  private var primaryLabel = UILabel()
  /// Label displaying the alternative letter.
  private var secondaryLabel = UILabel()
  /// The level of the key.
  private var level: Level = .primary {
    didSet { updateAppearance() }
  }
  
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initLabels()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initLabels()
  }
  
  
  // MARK: Configuration
  
  /**
   Update the letters that are displayed, and the level of the key.
   */
  func setLetters(primary: String, secondary: String, level: Level) {
    primaryLabel.text = primary
    secondaryLabel.text = secondary
    self.level = level
  }
  
  
  // MARK: Drawing
  
  /**
   Update theme appearance.
   */
  override func updateAppearance() {
    super.updateAppearance()
    switch level {
    case .primary:
      primaryLabel.textColor = ColorManager.shared.label
    case .secondary:
      primaryLabel.textColor = ColorManager.shared.secondaryLabel
    }
    secondaryLabel.textColor = ColorManager.shared.secondaryLabel
  }
  
  /**
   Initialize the labels.
   */
  func initLabels() {
    initPrimaryLabel()
    initSecondaryLabel()
  }
  
  /**
   Init the secondary label. The primary label should exist.
   */
  private func initSecondaryLabel() {
    secondaryLabel.font = .systemFont(ofSize: 12.0, weight: .light)
    secondaryLabel.textColor = ColorManager.shared.secondaryLabel
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
  
  /**
   Init the primary label.
   */
  private func initPrimaryLabel() {
    primaryLabel.font = .systemFont(ofSize: 20.0)
    primaryLabel.textColor = ColorManager.shared.label
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
