//
//  UI+Extension.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

// MARK: - Collection

extension Collection {
  
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
  
}

// MARK: - String

extension String {

  var isNumber: Bool {
    return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
  }
  
  func getElement(at charIndex: Int) -> String.Element {
    let index = self.index(startIndex, offsetBy: charIndex)
    return self[index]
  }
  
  func getSubSequence(from beginCharIndex: Int, to endCharIndex: Int) -> SubSequence {
    let beginIndex = index(startIndex, offsetBy: beginCharIndex)
    let endIndex = index(startIndex, offsetBy: endCharIndex)
    return self[beginIndex...endIndex]
  }
  
}

// MARK: - UIDevice

extension UIDevice {
  
  static var isPhone: Bool {
    return current.userInterfaceIdiom == .phone
  }
  
}

// MARK: - UIViewController

extension UIViewController {
  
  func add(_ child: UIViewController, with constraints: [NSLayoutConstraint]) {
    child.view.translatesAutoresizingMaskIntoConstraints = false
    willMove(toParent: self)
    view.addSubview(child.view)
    NSLayoutConstraint.activate(constraints)
    addChild(child)
    child.didMove(toParent: self)
  }
  
  func remove() {
    guard parent != nil else { return }
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
}

// MARK: - UIScreen

extension UIScreen {
  
  static var isPortrait: Bool {
    return main.bounds.width < main.bounds.height
  }
  
}

// MARK: - UIStackView

extension UIStackView {
  
  @discardableResult
  func removeAllArrangedSubviews() -> [UIView] {
    return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubviewWithoutWarning($1)] }
  }
  
  func removeArrangedSubviewWithoutWarning(_ view: UIView) -> UIView {
    removeArrangedSubview(view)
    NSLayoutConstraint.deactivate(view.constraints)
    view.removeFromSuperview()
    return view
  }
  
}
