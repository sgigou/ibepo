//
//  TextModifiersFactory.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-08.
//  Copyright © 2020 Novesoft. All rights reserved.
//


final class TextModifiersFactory {
  
  static func generate(for delegate: KeyboardActionProtocol) -> TextModifierSet {
    return TextModifierSet(modifiers: [
      DotInserter(delegate),
      SpaceRemover(delegate),
      NonBreakingSpaceInserter(delegate)
    ])
  }
  
}
