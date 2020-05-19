//
//  AutocorrectView.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - AutocorrectView

/// Displays autocorrect suggestions and allow to select one.
final class AutocorrectView: UIView {
  
  /// Collection view displaying words
  private(set) var collectionView: UICollectionView!
  
  
  // MARK: Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initView()
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    heightAnchor.constraint(equalToConstant: 40.0).isActive = true
  }
  
  
  // MARK: Init
  
  /**
   Adds the collection view.
   */
  private func initView() {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    layout.estimatedItemSize = CGSize(width: 100.0, height: 40.0)
    layout.scrollDirection = .horizontal
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    addSubview(collectionView)
    collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
  }
  
}
