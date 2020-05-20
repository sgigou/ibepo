//
//  KeyboardSettings.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeyboardSettings

/// Service that posts notifications if textDocumentProxy attributes change.
final class KeyboardSettings {
  
  /// Shared instance.
  static let shared = KeyboardSettings()
  
  /// Current text document proxy.
  let textDocumentProxyAnalyzer = TextDocumentProxyAnalyzer()
  
  /// Does the keyboard need to display keyboard switch key?
  var needsInputModeSwitchKey = false
  
  /// Current type of the return key.
  private(set) var returnKeyType: UIReturnKeyType = .default
  
  var shouldAutocorrect: Bool {
    return textDocumentProxyAnalyzer.textDocumentProxy?.autocorrectionType != .no
  }
  
  /**
   Check for updates in textDocumentProxy attributes.
   */
  func update(_ textDocumentProxy: UITextDocumentProxy) {
    Logger.debug("Text document proxy update.")
    textDocumentProxyAnalyzer.textDocumentProxy = textDocumentProxy
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
      NotificationCenter.default.post(name: .returnKeyTypeDidChange, object: nil)
    }
  }
  
}
