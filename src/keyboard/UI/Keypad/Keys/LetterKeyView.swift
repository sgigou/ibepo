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
  
  var currentLabelText: String? {
    return isAltActivated ? secondaryLabel.text : primaryLabel.text
  }
  var isAltActivated = false {
    didSet { updateAppearance() }
  }
  var level: Level = .primary {
    didSet { updateAppearance() }
  }
  
  private var primaryLabel = UILabel()
  private var secondaryLabel = UILabel()
  private var shouldDisplaySecondaryLetter = true
  
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  init(shouldDisplaySecondaryLetter: Bool) {
    super.init(frame: .zero)
    self.shouldDisplaySecondaryLetter = shouldDisplaySecondaryLetter
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
    let primaryColor = ColorManager.shared.label
    let shouldHideInactiveLabel = !shouldDisplaySecondaryLetter || (UIDevice.isPhone && !UIScreen.isPortrait)
    if isAltActivated {
      secondaryLabel.font = secondaryFont()
      secondaryLabel.textColor = primaryColor
      primaryLabel.font = primaryFont()
      primaryLabel.textColor = ColorManager.shared.secondaryLabel
      secondaryLabel.isHidden = false
      primaryLabel.isHidden = shouldHideInactiveLabel
    } else {
      secondaryLabel.font = secondaryFont()
      secondaryLabel.textColor = ColorManager.shared.secondaryLabel
      primaryLabel.font = primaryFont()
      primaryLabel.textColor = primaryColor
      secondaryLabel.isHidden = shouldHideInactiveLabel
      primaryLabel.isHidden = false
    }
    let alpha: CGFloat = (level == .primary) ? 1.0 : 0.75
    primaryLabel.alpha = alpha
    secondaryLabel.alpha = alpha
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
      secondaryLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
      secondaryLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
      secondaryLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 2)
    ])
    if !shouldDisplaySecondaryLetter {
      secondaryLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -2).isActive = true
    }
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
    if !shouldDisplaySecondaryLetter {
      primaryLabel.topAnchor.constraint(lessThanOrEqualTo: backgroundView.topAnchor, constant: 2).isActive = true
    }
  }

  private func primaryFont() -> UIFont {
    var size = CGFloat(30.0)
    if UIDevice.isPhone {
      if UIScreen.isPortrait {
        size = shouldDisplaySecondaryLetter ? 18.0 : 20.0
      } else {
        size = 16.0
      }
    }
    return .systemFont(ofSize: size, weight: .regular)
  }

  private func secondaryFont() -> UIFont {
    var size = CGFloat(16.0)
    if UIDevice.current.userInterfaceIdiom == .phone {
      if UIScreen.isPortrait {
        size = shouldDisplaySecondaryLetter ? 12.0 : 20.0
      }
    } else {
      size = shouldDisplaySecondaryLetter ? 16.0 : 30.0
    }
    let weight: UIFont.Weight = shouldDisplaySecondaryLetter ? .light : .regular
    return .systemFont(ofSize: size, weight: weight)
  }
  
}
