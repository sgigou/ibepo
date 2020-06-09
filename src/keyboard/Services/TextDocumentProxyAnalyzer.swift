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
  
  /// Currently editing word. An empty string if none.
  var currentWord: String {
    let context = findContext()
    var currentWord = ""
    for character in context.reversed() {
      if !character.isLetter && !["'", "’", "-"].contains(character) {
        break
      }
      currentWord.insert(character, at: currentWord.startIndex)
    }
    return currentWord
  }
  
  func getLastCharacters(amount: Int) -> String {
    if amount <= 0 { return "" }
    let context = findContext()
    return String(context.suffix(amount))
  }
  
  /**
   Find the context, based on the iOS version.
   
   - returns: Selected text, document context or an empty string.
   */
  func findContext() -> String {
    guard let textDocumentProxy = self.textDocumentProxy else {
      return ""
    }
    if #available(iOS 11.0, *) {
      return textDocumentProxy.selectedText ?? textDocumentProxy.documentContextBeforeInput ?? ""
    } else {
      return textDocumentProxy.documentContextBeforeInput ?? ""
    }
  }
  
}
