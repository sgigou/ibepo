//
//  DotInserter.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

class DotInserter {
  
  weak var delegate: KeyboardActionProtocol?
  
  convenience init(_ delegate: KeyboardActionProtocol) {
    self.init()
    self.delegate = delegate
  }
  
}

extension DotInserter: TextModifier {
  
  func modify() {
    let lastCharacters = KeyboardSettings.shared.textDocumentProxyAnalyzer.getLastCharacters(amount: 3)
    if lastCharacters.getSubSequence(from: 1, to: 2) != "  " { return }
    if !lastCharacters.getElement(at: 0).isLetter { return }
    delegate?.deleteBackward(amount: 2)
    delegate?.insert(text: ". ")
  }
  
  func deletionOccured() {
    
  }
  
  func moveOccured() {
    
  }
  
}
