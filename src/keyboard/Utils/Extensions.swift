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
