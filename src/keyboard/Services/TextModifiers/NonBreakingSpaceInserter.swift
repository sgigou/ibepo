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
  
  func modify() {}
  
  func deletionOccured() {}
  
  func moveOccured() {}
  
}
