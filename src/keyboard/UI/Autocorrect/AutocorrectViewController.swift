//
//  AutocorrectViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-19.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - AutocorrectViewController

/// Manages autocorrect and displaying suggestions.
final class AutocorrectViewController: UIViewController {
  
  /// Autocorrect engine.
  private let autocorrect = Autocorrect()
  
  
  // MARK: Life cycle
  
  override func loadView() {
    self.view = AutocorrectView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    autocorrect.delegate = self
    let view = self.view as! AutocorrectView
    view.collectionView.delegate = self
    view.collectionView.dataSource = self
    view.collectionView.register(AutocorrectCollectionViewCell.self, forCellWithReuseIdentifier: "AutocorrectCollectionViewCell")
  }
  
  
  // MARK: User input
  
  /**
   Updates the corrections.
   
   - parameter text: The letter inserted by the user, if any.
   */
  func update(_ text: String? = nil) {
    autocorrect.update(text)
  }
  
}


// MARK: - AutocorrectProtocol

extension AutocorrectViewController: AutocorrectProtocol {
  
  func autocorrectEnded(_ corrections: [Correction]) {
    DispatchQueue.main.sync {
      (view as! AutocorrectView).collectionView.reloadData()
    }
  }
  
}


// MARK: - UICollectionView

extension AutocorrectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return autocorrect.corrections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AutocorrectCollectionViewCell", for: indexPath) as? AutocorrectCollectionViewCell ?? AutocorrectCollectionViewCell()
    if indexPath.row < autocorrect.corrections.count {
      cell.configure(with: autocorrect.corrections[indexPath.row])
    }
    return cell
  }
  
}
