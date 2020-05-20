//
//  TextDocumentProxyAnalyzer.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-20.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


/// Calculator for the textDocumentProxy.
final class TextDocumentProxyAnalyzer {
  
  /// Up-to-date text document proxy
  var textDocumentProxy: UITextDocumentProxy?
  
  var currentWord: String {
    guard let textDocumentProxy = self.textDocumentProxy else {
      return ""
    }
    let context = textDocumentProxy.documentContextBeforeInput ?? ""
    var currentWord = ""
    for character in context.reversed() {
      if !character.isLetter {
        break
      }
      currentWord.insert(character, at: currentWord.startIndex)
    }
    return currentWord
  }
  
}
