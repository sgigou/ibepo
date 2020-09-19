//
//  NonBreakingSpaceInserter.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//


class NonBreakingSpaceInserter {
  
  weak var delegate: KeyboardActionProtocol?
  
  convenience init(_ delegate: KeyboardActionProtocol) {
    self.init()
    self.delegate = delegate
  }
  
}


extension NonBreakingSpaceInserter: TextModifier {
  
  func modify() {
    if !KeyboardSettings.shared.shouldAutocorrect { return }
    let lastCharacters = KeyboardSettings.shared.textDocumentProxyAnalyzer.getLastCharacters(amount: 3)
    if lastCharacters.count < 3 { return }
    if !lastCharacters.getElement(at: 0).isLetter { return }
    if lastCharacters.getElement(at: 1) != " " { return }
    let punctuation = (lastCharacters.last)!
    if !(["!", "?", ":", ";"].contains(punctuation)) { return }
    UniversalLogger.debug("Inserting a non-breaking space before '\(punctuation)'.")
    delegate?.deleteBackward(amount: 2)
    delegate?.insert(text: " \(String(punctuation))")
  }
  
  func deletionOccured() {}
  
  func moveOccured() {}
  
}
