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
  
  
  // MARK: User input
  
  func insert(_ text: String) {
    autocorrect.insert(text)
  }
  
}
