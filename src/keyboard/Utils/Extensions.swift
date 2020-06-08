//
//  UI+Extension.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-04.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

extension Collection {
  
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
  
}

extension String {
  
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

extension UIDevice {
  
  static var isPhone: Bool {
    return current.userInterfaceIdiom == .phone
  }
  
}

extension UIViewController {
  
  /**
   Add the given child view controller to the view controller, and activate given constraints.
   - parameter child: UIViewController to add.
   - parameter constraints: Constraints to automatically add and activate.
   - warning: This function will deactivate autoresizing mask translation.
   */
  func add(_ child: UIViewController, with constraints: [NSLayoutConstraint]) {
    child.view.translatesAutoresizingMaskIntoConstraints = false
    willMove(toParent: self)
    view.addSubview(child.view)
    NSLayoutConstraint.activate(constraints)
    addChild(child)
    child.didMove(toParent: self)
  }
  
  /**
   Remove the view controller from its parent.
   */
  func remove() {
    guard parent != nil else { return }
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
}

extension UIScreen {
  
  static var isPortrait: Bool {
    return main.bounds.width < main.bounds.height
  }
  
}

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
