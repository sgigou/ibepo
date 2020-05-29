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
  
  // MARK: Actions
  
  func hidePopup() {
    tailView.isHidden = true
    popupView.isHidden = true
  }
  
  func showPopup(over keyView: UIView) {
    guard let rowY = keyView.superview?.frame.minY else { return Logger.error("keyView should have a superview.") }
    tailView.frame = CGRect(
      x: keyView.frame.minX + Constants.keyHorizontalPadding + Constants.keyCornerRadius,
      y: rowY,
      width: keyView.frame.width - 2 * Constants.keyHorizontalPadding - 2 * Constants.keyCornerRadius,
      height: Constants.keyVerticalPadding
    )
    popupView.frame = CGRect(
      x: keyView.frame.minX,
      y: rowY - keyView.frame.height,
      width: keyView.frame.width,
      height: keyView.frame.height
    )
    updatePopupViewShadowPath()
    tailView.isHidden = false
    popupView.isHidden = false
  }
  
}
