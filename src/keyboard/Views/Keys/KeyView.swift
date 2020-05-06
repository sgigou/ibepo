//
//  KeyView.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// A key on the keypad.
class KeyView: UIView {
  
  var backgroundView: UIView!
  
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
  
  /**
   Creates and adds the background view for the letter.
   
   The view has ColorManager.background color by default.
   */
  func initBackground() {
    let backgroundView = UIView()
    backgroundView.backgroundColor = ColorManager.background
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.layer.cornerRadius = 5.0
    backgroundView.layer.shadowColor = UIColor.black.cgColor
    backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
    backgroundView.layer.shadowRadius = .zero
    backgroundView.layer.shadowOpacity = 0.25
    backgroundView.layer.shadowPath = UIBezierPath(roundedRect: backgroundView.bounds, cornerRadius: 5.0).cgPath
    addSubview(backgroundView)
    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
      backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -3),
      backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 3)
    ])
    self.backgroundView = backgroundView
  }
  
}
