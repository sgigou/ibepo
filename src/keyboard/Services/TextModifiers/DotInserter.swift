//
//  DotInserter.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

final class DotInserter {
  
  weak var delegate: KeyboardActionProtocol?
  
  private var isTemporaryDisabled = false
  
  convenience init(_ delegate: KeyboardActionProtocol) {
    self.init()
    self.delegate = delegate
  }
  
}


extension DotInserter: TextModifier {
  
  func modify() {
    if !KeyboardSettings.shared.shouldAutocorrect { return }
    if isTemporaryDisabled {
      let lastCharacter = KeyboardSettings.shared.textDocumentProxyAnalyzer.findContext().last
      if lastCharacter != nil && lastCharacter!.isLetter {
        isTemporaryDisabled = false
      }
      return
    }
    let lastCharacters = KeyboardSettings.shared.textDocumentProxyAnalyzer.getLastCharacters(amount: 3)
    if lastCharacters.count < 3 { return }
    if lastCharacters.getSubSequence(from: 1, to: 2) != "  " { return }
    if !lastCharacters.getElement(at: 0).isLetter { return }
    delegate?.deleteBackward(amount: 2)
    delegate?.insert(text: ". ")
  }
  
  func deletionOccured() {
    isTemporaryDisabled = true
  }
  
  func moveOccured() {
    isTemporaryDisabled = true
  }
  
}
