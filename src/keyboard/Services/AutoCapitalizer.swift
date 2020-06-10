//
//  AutoCapitalizer.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

final class AutoCapitalizer {
  
  // MARK: API
  
  func shouldCapitalize() -> Bool {
    let type = KeyboardSettings.shared.autoCapitalizationType
    switch type {
    case .allCharacters:
      return true
    case .words:
      return calculateForWordsType()
    case .sentences:
      return calculateForSentencesType()
    default:
      return false
    }
  }
  
  func shouldCapitalizeAfterDeletion() -> Bool {
    guard let lastCharacter = KeyboardSettings.shared.textDocumentProxyAnalyzer.findContext().last else {
      return false
    }
    return lastCharacter.isUppercase
  }
  
  // MARK: Calculations
  
  private func calculateForWordsType() -> Bool {
    guard let lastCharacter = KeyboardSettings.shared.textDocumentProxyAnalyzer.findContext().last else {
      return true
    }
    return lastCharacter.isWhitespace || lastCharacter.isNewline
  }
  
  private func calculateForSentencesType() -> Bool {
    guard let lastCharacter = KeyboardSettings.shared.textDocumentProxyAnalyzer.findContext().last else {
      return true
    }
    if lastCharacter.isNewline { return true }
    if !lastCharacter.isWhitespace { return false }
    let lastNonWhiteChar = KeyboardSettings.shared.textDocumentProxyAnalyzer.findContext().last { (Character) -> Bool in
      return !Character.isWhitespace
    }
    return lastNonWhiteChar != nil && [".", "!", "?", "…"].contains(lastNonWhiteChar!)
  }
  
}
