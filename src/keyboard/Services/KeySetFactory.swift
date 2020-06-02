//
//  KeySetFactory.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

/// Create a filled KeyList entity.
final class KeySetFactory {
  
  func generate() -> KeySet {
    var rows = [Row]()
    rows.append(generateRow1())
    rows.append(generateRow2())
    rows.append(generateRow3())
    return KeySet(rows: rows)
  }
  
  private func generateRow1() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, nil), level: .secondary))
    row.append(generateKey(for: CharacterSet("b", nil, nil, "1", nil, nil)))
    row.append(generateKey(for: CharacterSet("é", nil, nil, "2", nil, nil)))
    row.append(generateKey(for: CharacterSet("p", nil, nil, "3", nil, nil)))
    row.append(generateKey(for: CharacterSet("o", nil, nil, "4", nil, nil)))
    row.append(generateKey(for: CharacterSet("è", nil, nil, "5", nil, nil), level: .secondary))
    row.append(generateKey(for: CharacterSet("v", nil, nil, "6", nil, nil)))
    row.append(generateKey(for: CharacterSet("d", nil, nil, "7", nil, nil)))
    row.append(generateKey(for: CharacterSet("l", nil, nil, "8", nil, nil)))
    row.append(generateKey(for: CharacterSet("j", nil, nil, "9", nil, nil)))
    row.append(generateKey(for: CharacterSet("z", nil, nil, "0", nil, nil), level: .secondary))
    return row
  }
  
  private func generateRow2() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("ç", nil, nil, "@", nil, nil), level: .secondary))
    row.append(generateKey(for: CharacterSet("a", nil, nil, "&", nil, nil)))
    row.append(generateKey(for: CharacterSet("u", nil, nil, "œ", nil, nil)))
    row.append(generateKey(for: CharacterSet("i", nil, nil, "%", nil, nil)))
    row.append(generateKey(for: CharacterSet("e", nil, ["e", "é", "è"], "€", nil, ["€", "$"])))
    row.append(generateKey(for: CharacterSet("c", nil, nil, "’", nil, nil), level: .secondary))
    row.append(generateKey(for: CharacterSet("t", nil, nil, "+", nil, nil)))
    row.append(generateKey(for: CharacterSet("s", nil, nil, "-", nil, nil)))
    row.append(generateKey(for: CharacterSet("r", nil, nil, "/", nil, nil)))
    row.append(generateKey(for: CharacterSet("n", nil, nil, "*", nil, nil)))
    row.append(generateKey(for: CharacterSet("m", nil, nil, "=", nil, nil), level: .secondary))
    return row
  }
  
  private func generateRow3() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("à", nil, nil, "(", nil, nil)))
    row.append(generateKey(for: CharacterSet("y", nil, nil, ")", nil, nil)))
    row.append(generateKey(for: CharacterSet("x", nil, nil, ",", nil, nil)))
    row.append(generateKey(for: CharacterSet("k", nil, ["x", "k", "q"], "!", nil, nil)))
    row.append(generateKey(for: CharacterSet("q", nil, nil, "?", nil, nil)))
    row.append(generateKey(for: CharacterSet("g", nil, nil, ".", nil, nil)))
    row.append(generateKey(for: CharacterSet("h", nil, nil, "«", nil, nil)))
    row.append(generateKey(for: CharacterSet("f", nil, nil, "»", nil, nil)))
    return row
  }
  
  private func generateKey(for characterSet: CharacterSet, level: LetterKeyView.Level = .primary) -> Key {
    let view = LetterKeyView()
    view.setLetters(primary: characterSet.primaryLetter, secondary: characterSet.secondaryLetter, level: level)
    return Key(set: characterSet, view: view)
  }
  
}
