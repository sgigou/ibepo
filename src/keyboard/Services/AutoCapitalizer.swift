//
//  AutoCapitalizer.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

class AutoCapitalizer {
  
  func shouldCapitalize() -> Bool {
    let type = KeyboardSettings.shared.autoCapitalizationType
    switch type {
    case .allCharacters:
      return true
    case .words:
      return calculateForWordsType()
    default:
      return false
    }
  }
  
  private func calculateForWordsType() -> Bool {
    guard let lastCharacter = KeyboardSettings.shared.textDocumentProxyAnalyzer.findContext().last else {
      return true
    }
    return lastCharacter.isWhitespace || lastCharacter.isNewline
  }
  
}
