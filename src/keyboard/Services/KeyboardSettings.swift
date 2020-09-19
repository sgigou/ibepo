//
//  KeyboardSettings.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeyboardSettings

final class KeyboardSettings {
  
  static let shared = KeyboardSettings()
  
  let textDocumentProxyAnalyzer = TextDocumentProxyAnalyzer()
  
  var needsInputModeSwitchKey = false
  
  private(set) var returnKeyType: UIReturnKeyType = .default
  
  var shouldAutocorrect: Bool {
    return textDocumentProxyAnalyzer.textDocumentProxy?.autocorrectionType != .no
  }
  
  var autoCapitalizationType: UITextAutocapitalizationType {
    return textDocumentProxyAnalyzer.textDocumentProxy?.autocapitalizationType ?? .sentences
  }
  
  // MARK: Update
  
  func update(_ textDocumentProxy: UITextDocumentProxy) {
    textDocumentProxyAnalyzer.textDocumentProxy = textDocumentProxy
    updateAppearance(textDocumentProxy.keyboardAppearance ?? .default)
    updateReturnButton(textDocumentProxy.returnKeyType ?? .default)
  }
  
  private func updateAppearance(_ keyboardAppearance: UIKeyboardAppearance) {
    switch keyboardAppearance {
    case .light:
      ColorManager.shared.keyboardAppearance = .light
    case .dark:
      ColorManager.shared.keyboardAppearance = .dark
    default:
      ColorManager.shared.keyboardAppearance = .unspecified
    }
  }
  
  private func updateReturnButton(_ returnKeyType: UIReturnKeyType) {
    if self.returnKeyType != returnKeyType {
      UniversalLogger.debug("Return key type switching from \(self.returnKeyType.rawValue) to \(returnKeyType.rawValue)")
      self.returnKeyType = returnKeyType
      NotificationCenter.default.post(name: .returnKeyTypeDidChange, object: nil)
    }
  }
  
}
