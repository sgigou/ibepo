//
//  KeySetFactory.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

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
    row.append(generateKey(for: CharacterSet("w", nil, nil, "#", nil, ["#","¶","¬"]), level: .secondary))
    row.append(generateKey(for: CharacterSet("b", nil, nil, "1", nil, ["1","¹"])))
    row.append(generateKey(for: CharacterSet("é", nil, nil, "2", nil, ["2","½","²"])))
    row.append(generateKey(for: CharacterSet("p", nil, ["p","π"], "3", nil, ["3","³"])))
    row.append(generateKey(for: CharacterSet("o", nil, ["º","o","ò","ó","ô","õ","ö"], "4", nil, ["4","¼","¾"])))
    row.append(generateKey(for: CharacterSet("è", nil, ["è","´","^","`","~"], "5", nil, nil), level: .secondary))
    row.append(generateKey(for: CharacterSet("v", nil, ["◊","v","√"], "6", nil, nil)))
    row.append(generateKey(for: CharacterSet("d", nil, ["d","ð"], "7", nil, nil)))
    row.append(generateKey(for: CharacterSet("l", nil, nil, "8", nil, nil)))
    row.append(generateKey(for: CharacterSet("j", nil, nil, "9", nil, nil)))
    row.append(generateKey(for: CharacterSet("z", nil, nil, "0", nil, nil), level: .secondary))
    return row
  }
  
  private func generateRow2() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("ç", nil, nil, "@", nil, nil), level: .secondary))
    row.append(generateKey(for: CharacterSet("a", nil, ["ª","a","à","á","â","ã","ä","å"], "&", nil, ["","&","∞"])))
    row.append(generateKey(for: CharacterSet("u", nil, ["u","ù","ú","û","ü"], "œ", nil, ["œ","æ"])))
    row.append(generateKey(for: CharacterSet("i", nil, ["i","ì","í","î","ï"], "%", nil, ["°","%","‰"])))
    row.append(generateKey(for: CharacterSet("e", nil, ["e","è","é","ê","ë"], "€", nil, ["¤","€","$","¢","£","¥"])))
    row.append(generateKey(for: CharacterSet("c", nil, ["c","©"], "’", nil, ["'","\"","‘","’","“","”"]), level: .secondary))
    row.append(generateKey(for: CharacterSet("t", nil, ["t","þ","†","™"], "+", nil, ["+","±"])))
    row.append(generateKey(for: CharacterSet("s", nil, ["s","ß"], "-", nil, ["-","—","_"])))
    row.append(generateKey(for: CharacterSet("r", nil, ["r","®"], "/", nil, ["¦","|","÷","/","\\"])))
    row.append(generateKey(for: CharacterSet("n", nil, ["ñ","n"], "*", nil, ["·","*","×"])))
    row.append(generateKey(for: CharacterSet("m", nil, ["µ","m"], "=", nil, ["≈","≠","="]), level: .secondary))
    return row
  }
  
  private func generateRow3() -> Row {
    var row = Row()
    row.append(generateKey(for: CharacterSet("à", nil, ["à","ø"], "(", nil, ["(","[","{"])))
    row.append(generateKey(for: CharacterSet("y", nil, ["y","ý","ÿ"], ")", nil, [")","]","}"])))
    row.append(generateKey(for: CharacterSet("x", nil, nil, ",", nil, [",",";"])))
    row.append(generateKey(for: CharacterSet("k", nil, ["x", "k", "q"], "!", nil, ["!","¡"])))
    row.append(generateKey(for: CharacterSet("q", nil, nil, "?", nil, ["?","¿"])))
    row.append(generateKey(for: CharacterSet("g", nil, nil, ".", nil, ["…",".",":"])))
    row.append(generateKey(for: CharacterSet("h", nil, nil, "«", nil, ["≤","<","«"])))
    row.append(generateKey(for: CharacterSet("f", nil, nil, "»", nil, ["≥",">","»"])))
    return row
  }
  
  private func generateKey(for characterSet: CharacterSet, level: LetterKeyView.Level = .primary) -> Key {
    let view = LetterKeyView()
    view.setLetters(primary: characterSet.primaryLetter, secondary: characterSet.secondaryLetter, level: level)
    return Key(set: characterSet, view: view)
  }
  
}
