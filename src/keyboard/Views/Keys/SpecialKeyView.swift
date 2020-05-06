//
//  SystemKeyView.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// The display of a function key (like space or alt).
final class SpecialKeyView: KeyView {
  
  /// Label displaying the key function
  private var label: UILabel?
  
  /// Image displaying the key function
  private var imageView: UIImageView?
  
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
  
  func configure(withText text: String) {
    addLabel()
    label?.text = text
  }
  
  func configure(withImage image: UIImage) {
    addImageView()
    imageView?.image = image
  }
  
  // MARK: Drawing
  
  /**
   Use the label and removes the image (if needed).
   */
  private func addLabel() {
    if label != nil { return }
    guard let backgroundView = self.backgroundView else { return }
    imageView?.removeFromSuperview()
    imageView = nil
    label = UILabel()
    label!.font = .systemFont(ofSize: 20.0)
    label!.textColor = ColorManager.label
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
    guard let backgroundView = self.backgroundView else { return }
    label?.removeFromSuperview()
    label = nil
    imageView = UIImageView()
    imageView?.tintColor = ColorManager.label
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
