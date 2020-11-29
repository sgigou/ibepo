//
//  KeySetFactory.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

final class KeySetFactory {

  private let shouldDisplaySecondaryLetters = (Settings.get(for: .shouldDisplaySecondaryLetter) as? Bool) ?? true
  
  func generate() -> KeySet {
    var rows = [Row]()
    rows.append(generateRow1())
    rows.append(generateRow2())
    rows.append(generateRow3())
    return KeySet(rows: rows)
  }
  
  private func generateRow1() -> Row {
    var row = Row()
    row.append(generateKey(for: KeyCharacterSet("w", nil, nil, "#", nil, ["#","¶","¬"]), level: .secondary))
    row.append(generateKey(for: KeyCharacterSet("b", nil, nil, "1", nil, ["1","¹"])))
    row.append(generateKey(for: KeyCharacterSet("é", nil, nil, "2", nil, ["2","½","²"])))
    row.append(generateKey(for: KeyCharacterSet("p", nil, ["p","π"], "3", nil, ["3","³"])))
    row.append(generateKey(for: KeyCharacterSet("o", nil, ["º","o","ò","ó","ô","õ","ö"], "4", nil, ["4","¼","¾"])))
    row.append(generateKey(for: KeyCharacterSet("è", nil, ["è","´","^","`","~"], "5", nil, nil), level: .secondary))
    row.append(generateKey(for: KeyCharacterSet("v", nil, ["◊","v","√"], "6", nil, nil)))
    row.append(generateKey(for: KeyCharacterSet("d", nil, ["d","ð"], "7", nil, nil)))
    row.append(generateKey(for: KeyCharacterSet("l", nil, nil, "8", nil, nil)))
    row.append(generateKey(for: KeyCharacterSet("j", nil, nil, "9", nil, nil)))
    row.append(generateKey(for: KeyCharacterSet("z", nil, nil, "0", nil, nil), level: .secondary))
    return row
  }
  
  private func generateRow2() -> Row {
    var row = Row()
    row.append(generateKey(for: KeyCharacterSet("ç", nil, nil, "@", nil, nil), level: .secondary))
    row.append(generateKey(for: KeyCharacterSet("a", nil, ["ª","a","à","á","â","ã","ä","å"], "&", nil, ["","&","∞"])))
    row.append(generateKey(for: KeyCharacterSet("u", nil, ["u","ù","ú","û","ü"], "œ", nil, ["œ","æ"])))
    row.append(generateKey(for: KeyCharacterSet("i", nil, ["i","ì","í","î","ï"], "%", nil, ["°","%","‰"])))
    row.append(generateKey(for: KeyCharacterSet("e", nil, ["e","è","é","ê","ë"], "€", nil, ["¤","€","$","¢","£","¥"])))
    row.append(generateKey(for: KeyCharacterSet("c", nil, ["c","©"], "’", nil, ["'","\"","‘","’","“","”"]), level: .secondary))
    row.append(generateKey(for: KeyCharacterSet("t", nil, ["t","þ","†","™"], "+", nil, ["+","±"])))
    row.append(generateKey(for: KeyCharacterSet("s", nil, ["s","ß"], "-", nil, ["-","—","_"])))
    row.append(generateKey(for: KeyCharacterSet("r", nil, ["r","®"], "/", nil, ["¦","|","÷","/","\\"])))
    row.append(generateKey(for: KeyCharacterSet("n", nil, ["ñ","n"], "*", nil, ["·","*","×"])))
    row.append(generateKey(for: KeyCharacterSet("m", nil, ["µ","m"], "=", nil, ["≈","≠","="]), level: .secondary))
    return row
  }
  
  private func generateRow3() -> Row {
    var row = Row()
    row.append(generateKey(for: KeyCharacterSet("à", nil, ["à","ø"], "(", nil, ["(","[","{"])))
    row.append(generateKey(for: KeyCharacterSet("y", nil, ["y","ý","ÿ"], ")", nil, [")","]","}"])))
    row.append(generateKey(for: KeyCharacterSet("x", nil, nil, ",", nil, [",",";"])))
    row.append(generateKey(for: KeyCharacterSet("k", nil, nil, "!", nil, ["!","¡"])))
    row.append(generateKey(for: KeyCharacterSet("q", nil, nil, "?", nil, ["?","¿"])))
    row.append(generateKey(for: KeyCharacterSet("g", nil, nil, ".", nil, ["…",".",":"])))
    row.append(generateKey(for: KeyCharacterSet("h", nil, nil, "«", nil, ["≤","<","«"])))
    row.append(generateKey(for: KeyCharacterSet("f", nil, nil, "»", nil, ["≥",">","»"])))
    return row
  }
  
  private func generateKey(for characterSet: KeyCharacterSet, level: LetterKeyView.Level = .primary) -> Key {
    let view = LetterKeyView(shouldDisplaySecondaryLetter: shouldDisplaySecondaryLetters)
    view.setLetters(primary: characterSet.primaryLetter, secondary: characterSet.secondaryLetter, level: level)
    return Key(set: characterSet, view: view)
  }
  
}
