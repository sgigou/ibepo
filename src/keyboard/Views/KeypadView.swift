//
//  KeypadView.swift
//  keyboard
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - KeypadView

/// All the KeyView
final class KeypadView: UIView {
  
  /// The multiplier to use on widthAnchor to get the width of a key.
  private let keyWidthMultiplier: CGFloat = 1/11
  
  private var shiftKeyView: SpecialKeyView?
  private var deleteKeyView: SpecialKeyView?
  private var altKeyView: SpecialKeyView?
  private var switchKeyView: SpecialKeyView?
  private var spaceKeyView: SpecialKeyView?
  private var returnKeyView: SpecialKeyView?
  
  
  /// MARK: Drawing
  
  /**
   Update the theme appearance.
  */
  func updateAppearance() {
    shiftKeyView?.updateAppearance()
    deleteKeyView?.updateAppearance()
    altKeyView?.updateAppearance()
    switchKeyView?.updateAppearance()
    spaceKeyView?.updateAppearance()
    returnKeyView?.updateAppearance()
  }
  
  
  /// MARK: Loading
  
  /**
   Load the given keyset and creates views for the rows and the letters.
   - parameter keySet: The KeySet to load and display.
   */
  func load(keySet: KeySet) {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = UIColor.gray.withAlphaComponent(0.001) // Gestures do not work on transparent view.
    heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    
    let rowView1 = addRowView(topAnchor: topAnchor)
    var lastKey = parse(keySet.rows[0], in: rowView1)
    lastKey.rightAnchor.constraint(equalTo: rowView1.rightAnchor).isActive = true
    
    let rowView2 = addRowView(topAnchor: rowView1.bottomAnchor)
    lastKey = parse(keySet.rows[1], in: rowView2)
    lastKey.rightAnchor.constraint(equalTo: rowView2.rightAnchor).isActive = true
    
    let rowView3 = addRowView(topAnchor: rowView2.bottomAnchor)
    shiftKeyView = addSpecial(in: rowView3, widthMultiplier: keyWidthMultiplier*1.5, leftAnchor: rowView3.leftAnchor)
    shiftKeyView!.configure(withImage: SymbolsManager.getImage(named: "shift"), level: .secondary)
    lastKey = parse(keySet.rows[2], in: rowView3, leftAnchor: shiftKeyView!.rightAnchor)
    deleteKeyView = addSpecial(in: rowView3, widthMultiplier: keyWidthMultiplier*1.5, leftAnchor: lastKey.rightAnchor)
    deleteKeyView!.rightAnchor.constraint(equalTo: rowView3.rightAnchor).isActive = true
    deleteKeyView!.configure(withImage: SymbolsManager.getImage(named: "delete.left"), level: .secondary)
    
    let rowView4 = addRowView(topAnchor: rowView3.bottomAnchor, bottomAnchor: bottomAnchor)
    altKeyView = addSpecial(in: rowView4, widthMultiplier: keyWidthMultiplier*3, leftAnchor: rowView4.leftAnchor)
    altKeyView!.configure(withImage: SymbolsManager.getImage(named: "option"), level: .secondary)
    spaceKeyView = addSpecial(in: rowView4, widthMultiplier: keyWidthMultiplier*5, leftAnchor: altKeyView!.rightAnchor)
    spaceKeyView!.configure(withText: "Espace", level: .primary)
    returnKeyView = addSpecial(in: rowView4, widthMultiplier: keyWidthMultiplier*3, leftAnchor: spaceKeyView!.rightAnchor)
    returnKeyView!.rightAnchor.constraint(equalTo: rowView4.rightAnchor).isActive = true
    returnKeyView!.configure(withImage: SymbolsManager.getImage(named: "return"), level: .secondary)
  }
  
  /**
   Creates and adds a row view that will contain letter views.
   - parameter topAnchor: The top constraint to stick to.
   - parameter bottomAnchor: The bottom constraint to stick to. If null, then no bottom constraint is added.
   - returns: The created row view.
   */
  private func addRowView(topAnchor: NSLayoutYAxisAnchor, bottomAnchor: NSLayoutYAxisAnchor? = nil) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
    view.topAnchor.constraint(equalTo: topAnchor).isActive = true
    view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    if let bottomAnchor = bottomAnchor {
      view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    return view
  }
  
  /**
   Parse the given row to generate key views.
   - parameter row: Row to parse.
   - parameter rowView: Row view in which insert key views.
   - parameter leftAnchor: Custom left anchor to stick the first key. If nil, then rowView.leftAnchor will be used.
   - returns: The last key view created.
   */
  private func parse(_ row: Row, in rowView: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil) -> LetterKeyView {
    var leftAnchor = leftAnchor ?? rowView.leftAnchor
    for key in row {
      add(key, in: rowView, leftAnchor: leftAnchor)
      leftAnchor = key.view.rightAnchor
    }
    return row.last!.view
  }
  
  /**
   Add the given key.view to the given row, sticking to leftAnchor.
   */
  private func add(_ key: Key, in row: UIView, leftAnchor: NSLayoutXAxisAnchor) {
    key.view.translatesAutoresizingMaskIntoConstraints = false
    row.addSubview(key.view)
    key.view.widthAnchor.constraint(equalTo: row.widthAnchor, multiplier: 1 / 11).isActive = true
    key.view.topAnchor.constraint(equalTo: row.topAnchor).isActive = true
    key.view.bottomAnchor.constraint(equalTo: row.bottomAnchor).isActive = true
    key.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
  }
  
  /**
   Adds a special key to the given row.
   - parameter rowView: Where to add the newly created SpecialKeyView.
   - parameter widthMultiplier: The width multiplier that will be used on rowView.widthAnchor.
   - parameter leftAnchor: Where to stick the SpecialKeyView after insertion.
   */
  private func addSpecial(in rowView: UIView, widthMultiplier: CGFloat, leftAnchor: NSLayoutXAxisAnchor) -> SpecialKeyView {
    let specialKeyView = SpecialKeyView()
    specialKeyView.translatesAutoresizingMaskIntoConstraints = false
    rowView.addSubview(specialKeyView)
    specialKeyView.widthAnchor.constraint(equalTo: rowView.widthAnchor, multiplier: widthMultiplier).isActive = true
    specialKeyView.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
    specialKeyView.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true
    specialKeyView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    return specialKeyView
  }
  
}
