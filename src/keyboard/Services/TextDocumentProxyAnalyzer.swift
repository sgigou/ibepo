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
class TextDocumentProxyAnalyzer {
  
  private var returnKeyType: UIReturnKeyType = .default
  
  /**
   Check for updates in textDocumentProxy attributes.
   */
  func update(_ textDocumentProxy: UITextDocumentProxy) {
    Logger.debug("Text document proxy update.")
    updateAppearance(textDocumentProxy.keyboardAppearance ?? .default)
    updateReturnButton(textDocumentProxy.returnKeyType ?? .default)
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
  
  /**
   Updates the return button appearance.
   */
  private func updateReturnButton(_ returnKeyType: UIReturnKeyType) {
    if self.returnKeyType != returnKeyType {
      Logger.debug("Return key type switching from \(self.returnKeyType.rawValue) to \(returnKeyType.rawValue)")
      self.returnKeyType = returnKeyType
      let userInfo = ["returnKeyType": returnKeyType]
      NotificationCenter.default.post(name: .returnKeyTypeDidChange, object: nil, userInfo: userInfo)
    }
  }
  
}
