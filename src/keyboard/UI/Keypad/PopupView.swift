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
    setupTailView()
    setupPopupView()
    hidePopup()
  }
  
  private func setupTailView() {
    tailView.backgroundColor = ColorManager.shared.background
    addSubview(tailView)
  }
  
  private func setupPopupView() {
    // TODO: Code it
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
    tailView.isHidden = false
  }
  
}
