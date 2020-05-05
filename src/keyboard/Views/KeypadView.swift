//
//  KeypadView.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

/// All the KeyView
class KeypadView: UIView {
  
  var rowStackView: UIStackView!
  
  func initRowStack() {
    rowStackView = UIStackView()
    rowStackView.translatesAutoresizingMaskIntoConstraints = false
    rowStackView.axis = .vertical
    rowStackView.distribution = .fillEqually
    rowStackView.alignment = .fill
    addSubview(rowStackView)
    NSLayoutConstraint.activate([
      rowStackView.topAnchor.constraint(equalTo: topAnchor),
      rowStackView.rightAnchor.constraint(equalTo: rightAnchor),
      rowStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      rowStackView.leftAnchor.constraint(equalTo: leftAnchor)
    ])
  }
  
  func add(keySet: KeySet) {
    let row1 = addKeyStack()
    add(row: keySet.rows[0], to: row1)
    
    let row2 = addKeyStack()
    add(row: keySet.rows[1], to: row2)
    
    let row3 = addKeyStack()
    // TODO: Clean the special key generation
    let maj = SpecialKeyView()
    row3.addArrangedSubview(maj)
    add(row: keySet.rows[2], to: row3)
    let del = SpecialKeyView()
    row3.addArrangedSubview(del)
    
    let row4 = addKeyStack()
    let alt = SpecialKeyView()
    row4.addArrangedSubview(alt)
    let space = SpecialKeyView()
    row4.addArrangedSubview(space)
    let ret = SpecialKeyView()
    row4.addArrangedSubview(ret)
  }
  
  func addKeyStack() -> UIStackView {
    let keyStackView = UIStackView()
    keyStackView.translatesAutoresizingMaskIntoConstraints = false
    keyStackView.axis = .horizontal
    keyStackView.distribution = .fillProportionally
    keyStackView.alignment = .fill
    rowStackView.addArrangedSubview(keyStackView)
    return keyStackView
  }
  
  func add(row: Row, to keyStack: UIStackView) {
    for key in row {
      keyStack.addArrangedSubview(key.view)
    }
  }
  
}
