//
//  PopupView.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-29.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

// MARK: - PopupView

/// Displays the key letter and its subletters.
final class PopupView: UIView {
  
  private let tailView = UIView()
  private let popupView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
  private let letterStackView = UIStackView(arrangedSubviews: [])
  
  private var hideDelayTimer = Timer()
  
  private lazy var subLetterFont: UIFont = {
    let fontSize: CGFloat = UIDevice.isPhone ? 30.0 : 50.0
    return .systemFont(ofSize: fontSize, weight: .light)
  }()
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  // MARK: Setup
  
  private func setupViews() {
    setupPopupView()
    setupTailView()
    setupLetterStackView()
    hidePopup()
  }
  
  private func setupTailView() {
    tailView.backgroundColor = ColorManager.shared.background
    addSubview(tailView)
  }
  
  private func setupPopupView() {
    popupView.backgroundColor = ColorManager.shared.background
    popupView.layer.cornerRadius = Constants.keyCornerRadius
    popupView.layer.shadowColor = UIColor.black.cgColor
    popupView.layer.shadowOffset = CGSize(width: 0, height: Constants.keyShadowOffset)
    popupView.layer.shadowRadius = 2 * Constants.keyShadowOffset
    popupView.layer.shadowOpacity = 0.25
    popupView.layer.shadowPath = .none
    addSubview(popupView)
  }
  
  private func updatePopupViewShadowPath() {
    popupView.layer.shadowPath = UIBezierPath(roundedRect: popupView.bounds, cornerRadius: Constants.keyCornerRadius).cgPath
  }
  
  private func setupLetterStackView() {
    letterStackView.distribution = .fillEqually
    letterStackView.spacing = Constants.keyHorizontalPadding * 2
    letterStackView.translatesAutoresizingMaskIntoConstraints = false
    popupView.addSubview(letterStackView)
    letterStackView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: Constants.keyVerticalPadding).isActive = true
    letterStackView.rightAnchor.constraint(equalTo: popupView.rightAnchor, constant: -Constants.keyHorizontalPadding).isActive = true
    letterStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -Constants.keyVerticalPadding).isActive = true
    letterStackView.leftAnchor.constraint(equalTo: popupView.leftAnchor, constant: Constants.keyHorizontalPadding).isActive = true
  }
  
  func updateAppearance() {
    tailView.backgroundColor = ColorManager.shared.background
    popupView.backgroundColor = ColorManager.shared.background
  }
  
  // MARK: Actions
  
  func hidePopup() {
    hideDelayTimer.invalidate()
    hideDelayTimer = Timer(timeInterval: Constants.popupHideDelay, target: self, selector: #selector(hidePopupParts), userInfo: nil, repeats: false)
    hideDelayTimer.tolerance = Constants.popupHideDelay / 2
    RunLoop.current.add(hideDelayTimer, forMode: .common)
  }
  
  @objc func hidePopupParts() {
    DispatchQueue.main.async {
      [weak self] in
      self?.tailView.isHidden = true
      self?.popupView.isHidden = true
    }
  }
  
  func showPopup(for key: Key) {
    hideDelayTimer.invalidate()
    guard let rowY = key.view.superview?.frame.minY else {
      return UniversalLogger.error("keyView should have a superview.")
    }
    tailView.frame = CGRect(
      x: key.view.frame.minX + Constants.keyHorizontalPadding + Constants.keyCornerRadius,
      y: rowY,
      width: key.view.frame.width - 2 * Constants.keyHorizontalPadding - 2 * Constants.keyCornerRadius,
      height: Constants.keyVerticalPadding
    )
    popupView.frame = CGRect(
      x: key.view.frame.minX,
      y: rowY - key.view.frame.height,
      width: key.view.frame.width,
      height: key.view.frame.height
    )
    updatePopupViewShadowPath()
    tailView.isHidden = false
    popupView.isHidden = false
    let currentLetter = key.view.currentLabelText ?? "�"
    generateLetterStackViewList(for: [currentLetter])
  }
  
  func showPopupWithSubLetters(for key: Key, shiftState: Key.State, altState: Key.State) {
    hideDelayTimer.invalidate()
    guard let rowY = key.view.superview?.frame.minY else {
      return UniversalLogger.error("keyView should have a superview.")
    }
    tailView.frame = CGRect(
      x: key.view.frame.minX + Constants.keyHorizontalPadding + Constants.keyCornerRadius,
      y: rowY,
      width: key.view.frame.width - 2 * Constants.keyHorizontalPadding - 2 * Constants.keyCornerRadius,
      height: Constants.keyVerticalPadding
    )
    let keyLetter = key.set.letter(forShiftState: shiftState, andAltState: altState)
    let letters = key.set.subLetters(forShiftState: shiftState, andAltState: altState)
    var beforeLetters = 0
    var afterLetters = 0
    var keyLetterFound = false
    for letter in letters {
      if letter == keyLetter {
        keyLetterFound = true
        continue
      }
      if keyLetterFound {
        afterLetters += 1
      } else {
        beforeLetters += 1
      }
    }
    popupView.frame = CGRect(
      x: key.view.frame.minX - CGFloat(beforeLetters) * key.view.frame.width,
      y: rowY - key.view.frame.height,
      width: key.view.frame.width * CGFloat(beforeLetters + 1 + afterLetters),
      height: key.view.frame.height
    )
    updatePopupViewShadowPath()
    tailView.isHidden = false
    popupView.isHidden = false
    generateLetterStackViewList(for: letters)
    select(subLetter: keyLetter)
  }
  
  // MARK: Letter stack view
  
  func select(subLetter: String) {
    for case let label as UILabel in letterStackView.arrangedSubviews {
      if label.text == subLetter {
        label.font = subLetterFont
        label.textColor = ColorManager.shared.colorAppearance == .dark ? ColorManager.shared.label : ColorManager.shared.background
        label.backgroundColor = ColorManager.shared.mainColor
      } else {
        label.font = subLetterFont
        label.textColor = ColorManager.shared.label
        label.backgroundColor = .clear
      }
    }
  }
  
  private func generateLetterStackViewList(for letters: [String]) {
    letterStackView.removeAllArrangedSubviews()
    for letter in letters {
      letterStackView.addArrangedSubview(generateLetterView(for: letter))
    }
  }
  
  private func generateLetterView(for letter: String) -> UILabel {
    let label = UILabel()
    label.font = subLetterFont
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.text = letter
    label.layer.cornerRadius = Constants.keyCornerRadius
    label.clipsToBounds = true
    return label
  }
  
}
