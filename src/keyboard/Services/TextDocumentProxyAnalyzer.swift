//
//  TextDocumentProxyAnalyzer.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - TextDocumentProxyAnalyzer

/// Service that posts notifications if textDocumentProxy attributes change.
struct TextDocumentProxyAnalyzer {
  
  /**
   Check for updates in textDocumentProxy attributes.
   */
  func update(_ textDocumentProxy: UITextDocumentProxy) {
    Logger.debug("Text document proxy update.")
    updateAppearance(textDocumentProxy.keyboardAppearance ?? .default)
  }
  
  /**
   Updates the appearance of the keyboard if needed.
   */
  private func updateAppearance(_ keyboardAppearance: UIKeyboardAppearance) {
    if ColorManager.shared.keyboardAppearance != keyboardAppearance {
      Logger.debug("Keyboard appearance switching from \(ColorManager.shared.keyboardAppearance.rawValue) to \(keyboardAppearance.rawValue)")
      ColorManager.shared.keyboardAppearance = keyboardAppearance
      NotificationCenter.default.post(name: .keyboardAppearanceDidChange, object: nil)
    }
  }
  
}
