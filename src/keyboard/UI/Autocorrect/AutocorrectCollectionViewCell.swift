//
//  AutocorrectCollectionViewCell.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - AutocorrectCollectionViewCell

/// Displays a correction in the autocorrect collection view.
final class AutocorrectCollectionViewCell: UICollectionViewCell {
  
  private let label = UILabel()
  
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialDraw()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialDraw()
  }
  
  
  // MARK: Drawing
  
  private func initialDraw() {
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 40.0)
  }
  
  
  // MARK: Configuration
  
  func configure(with correction: Correction) {
    label.text = correction.word
  }

}
