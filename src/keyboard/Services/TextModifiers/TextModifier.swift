//
//  TextModifierProtocol.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//


protocol TextModifier {
  
  func modify()
  func deletionOccured()
  func moveOccured()
  
}


struct TextModifierSet {
  
  let modifiers: [TextModifier]
  
  init(modifiers: [TextModifier]) {
    self.modifiers = modifiers
  }
  
  func modify() {
    for modifier in modifiers {
      modifier.modify()
    }
  }
  
  func deletionOccured() {
    for modifier in modifiers {
      modifier.deletionOccured()
    }
  }
  
  func moveOccured() {
    for modifier in modifiers {
      modifier.moveOccured()
    }
  }
  
}
