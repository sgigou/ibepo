//
//  PopupView.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-29.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

// MARK: - PopupView

/// Displays the magnifying popup over letter keys.
class PopupView: UIView {
  
  private let tailView = UIView()
  private let popupView = UIView()
  private let letterStackView = UIStackView(arrangedSubviews: [])
  
  private lazy var lettersFont: UIFont = {
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
    letterStackView.translatesAutoresizingMaskIntoConstraints = false
    popupView.addSubview(letterStackView)
    letterStackView.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
    letterStackView.rightAnchor.constraint(equalTo: popupView.rightAnchor).isActive = true
    letterStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
    letterStackView.leftAnchor.constraint(equalTo: popupView.leftAnchor).isActive = true
  }
  
  // MARK: Actions
  
  func hidePopup() {
    tailView.isHidden = true
    popupView.isHidden = true
  }
  
  func showPopup(for key: Key) {
    guard let rowY = key.view.superview?.frame.minY else {
      return Logger.error("keyView should have a superview.")
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
    guard let rowY = key.view.superview?.frame.minY else {
      return Logger.error("keyView should have a superview.")
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
  }
  
  // MARK: Letter stack view
  
  func selectSubLetter(at index: Int) {
    Logger.debug("Letter selected at \(index)")
  }
  
  private func generateLetterStackViewList(for letters: [String]) {
    letterStackView.removeAllArrangedSubviews()
    for letter in letters {
      letterStackView.addArrangedSubview(generateLetterView(for: letter))
    }
  }
  
  private func generateLetterView(for letter: String) -> UILabel {
    let label = UILabel()
    label.font = lettersFont
    label.textAlignment = .center
    label.text = letter
    return label
  }
  
}
