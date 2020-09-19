//
//  SpaceRemover.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import Foundation


final class SpaceRemover {
  
  weak var delegate: KeyboardActionProtocol?
  
  private var isActivated = false
  
  convenience init(_ delegate: KeyboardActionProtocol) {
    self.init()
    self.delegate = delegate
    NotificationCenter.default.addObserver(self, selector: #selector(userSelectedASuggestion), name: .userSelectedASuggestion, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func userSelectedASuggestion() {
    isActivated = true
  }
  
}


extension SpaceRemover: TextModifier {
  
  func modify() {
    if !isActivated { return }
    isActivated = false
    let lastCharacters = KeyboardSettings.shared.textDocumentProxyAnalyzer.getLastCharacters(amount: 3)
    if lastCharacters.count < 3 { return }
    if !lastCharacters.getElement(at: 0).isLetter { return }
    if lastCharacters.getElement(at: 1) != " " { return }
    let punctuation = (lastCharacters.last)!
    if !([".", ",", "…"].contains(punctuation)) { return }
    UniversalLogger.debug("Removing space before '\(punctuation)'.")
    delegate?.deleteBackward(amount: 2)
    delegate?.insert(text: String(punctuation))
  }
  
  func deletionOccured() {
    isActivated = false
  }
  
  func moveOccured() {
    isActivated = false
  }
  
}
