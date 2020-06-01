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
  
  /// Indicates if the alt display is activated.
  var isAltActivated = false {
    didSet { updateAppearance() }
  }
  /// The level of the key.
  var level: Level = .primary {
    didSet { updateAppearance() }
  }
  
  /// Label displaying the main letter.
  private var primaryLabel = UILabel()
  /// Label displaying the alternative letter.
  private var secondaryLabel = UILabel()
  
  private var primaryFontSize: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone {
      if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
        return 20.0
      } else {
        return 16.0
      }
    } else {
      return 30.0
    }
  }
  private var secondaryFontSize: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone {
      if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
        return 12.0
      } else {
        return 10.0
      }
    } else {
      return 16.0
    }
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
   
   - parameter level: Level to apply to the key. If none is given, then the level will not be changed.
   */
  func setLetters(primary: String, secondary: String, level: Level? = nil) {
    primaryLabel.text = primary
    secondaryLabel.text = secondary
    if let level = level { self.level = level }
  }
  
  
  // MARK: Drawing
  
  /**
   Update theme appearance.
   */
  override func updateAppearance() {
    super.updateAppearance()
    let primaryColor = level == .primary ? ColorManager.shared.label : ColorManager.shared.secondaryLabel
    let primaryWeight: UIFont.Weight = UIDevice.current.userInterfaceIdiom == .phone ? .regular : .light
    if isAltActivated {
      secondaryLabel.font = .systemFont(ofSize: secondaryFontSize, weight: primaryWeight)
      secondaryLabel.textColor = primaryColor
      primaryLabel.font = .systemFont(ofSize: primaryFontSize, weight: .light)
      primaryLabel.textColor = ColorManager.shared.secondaryLabel
    } else {
      secondaryLabel.font = .systemFont(ofSize: secondaryFontSize, weight: .light)
      secondaryLabel.textColor = ColorManager.shared.secondaryLabel
      primaryLabel.font = .systemFont(ofSize: primaryFontSize, weight: primaryWeight)
      primaryLabel.textColor = primaryColor
    }
  }
  
  /**
   Initialize the labels.
   */
  func initLabels() {
    initPrimaryLabel()
    initSecondaryLabel()
    updateAppearance()
  }
  
  /**
   Init the secondary label. The primary label should exist.
   */
  private func initSecondaryLabel() {
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
