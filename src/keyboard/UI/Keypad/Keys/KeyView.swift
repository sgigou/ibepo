//
//  KeyView.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeyView

class KeyView: UIView {
  
  var backgroundView: UIView!
  var isHighlighted = false
  var isPressed = false
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initBackground()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let backgroundView = self.backgroundView {
      backgroundView.layer.shadowPath = UIBezierPath(roundedRect: backgroundView.bounds, cornerRadius: 5.0).cgPath
    }
  }
  
  // MARK: Display
  
  func updateAppearance() {
    backgroundView.backgroundColor = ColorManager.shared.background
  }
  
  func initBackground() {
    let backgroundView = UIView()
    backgroundView.backgroundColor = ColorManager.shared.background
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.layer.cornerRadius = Constants.keyCornerRadius
    backgroundView.layer.shadowColor = UIColor.black.cgColor
    backgroundView.layer.shadowOffset = CGSize(width: 0, height: Constants.keyShadowOffset)
    backgroundView.layer.shadowRadius = .zero
    backgroundView.layer.shadowOpacity = 0.25
    backgroundView.layer.shadowPath = UIBezierPath(roundedRect: backgroundView.bounds, cornerRadius: Constants.keyCornerRadius).cgPath
    addSubview(backgroundView)
    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.keyVerticalPadding),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.keyVerticalPadding),
      backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.keyHorizontalPadding),
      backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.keyHorizontalPadding)
    ])
    self.backgroundView = backgroundView
  }
  
  func togglePression() {
    isPressed.toggle()
    if isPressed {
      backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
    } else {
      backgroundView.layer.shadowOffset = CGSize(width: 0, height: Constants.keyShadowOffset)
    }
  }
  
}
