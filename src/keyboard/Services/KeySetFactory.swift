//
//  KeySetFactory.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

/// Create a filled KeyList entity.
class KeySetFactory {
  
  func generate() -> KeySet {
    var rows = [Row]()
    rows.append(generateRow1())
    rows.append(generateRow2())
    rows.append(generateRow3())
    return KeySet(rows: rows)
  }
  
  private func generateRow1() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    return row
  }
  
  private func generateRow2() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    return row
  }
  
  private func generateRow3() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil)))
    return row
  }
  
  private func generateKey(for characterSet: CharacterSet) -> Key {
    return Key(set: characterSet, view: LetterKeyView())
  }
  
}
