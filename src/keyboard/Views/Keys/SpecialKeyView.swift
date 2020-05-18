//
//  SystemKeyView.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - SpecialKeyView

/// The display of a function key (like space or alt).
final class SpecialKeyView: KeyView {
  
  /// Primary functions are displayed in bright, secondary are lighter.
  enum Level {
    case primary, secondary
  }
  
  
  /// Label displaying the key function
  private var label: UILabel?
  /// Image displaying the key function
  private var imageView: UIImageView?
  /// View level
  private var level: Level = .primary {
    didSet { updateAppearance() }
  }
  
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addLabel()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addLabel()
  }
  
  
  // MARK: Configuration
  
  /**
   Configure the key with a label.
   */
  func configure(withText text: String, level: Level) {
    addLabel()
    label?.text = text
    self.level = level
  }
  
  /**
   Configure the key with a symbol.
   */
  func configure(withImage image: UIImage, level: Level) {
    addImageView()
    imageView?.image = image
    self.level = level
  }
  
  
  // MARK: Drawing
  
  /**
   Update theme appearance.
   */
  override func updateAppearance() {
    super.updateAppearance()
    if isHighlighted {
      imageView?.tintColor = .white
      label?.textColor = .white
      backgroundView.backgroundColor = ColorManager.shared.mainColor
    } else {
      imageView?.tintColor = ColorManager.shared.label
      label?.textColor = ColorManager.shared.label
      switch level {
      case .primary:
        backgroundView.backgroundColor = ColorManager.shared.background
      case .secondary:
        backgroundView.backgroundColor = ColorManager.shared.secondaryBackground
      }
    }
  }
  
  /**
   Use the label and removes the image (if needed).
   */
  private func addLabel() {
    if label != nil { return }
    imageView?.removeFromSuperview()
    imageView = nil
    label = UILabel()
    label!.font = .systemFont(ofSize: 20.0)
    label!.textColor = ColorManager.shared.label
    label!.textAlignment = .center
    label!.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label!)
    NSLayoutConstraint.activate([
      label!.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 2),
      label!.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
      label!.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -2),
      label!.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
    ])
  }
  
  /**
   Adds the image and removes the label (if needed).
   */
  private func addImageView() {
    if imageView != nil { return }
    label?.removeFromSuperview()
    label = nil
    imageView = UIImageView()
    imageView?.tintColor = ColorManager.shared.label
    imageView?.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView!)
    NSLayoutConstraint.activate([
      imageView!.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
      imageView!.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
      imageView!.widthAnchor.constraint(equalToConstant: 22),
      imageView!.heightAnchor.constraint(equalToConstant: 22),
    ])
  }
  
}
