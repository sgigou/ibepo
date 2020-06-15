//
//  MainViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-06-15.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - MainViewController

class MainViewController: UIViewController {

  @IBOutlet weak var testTextField: UITextField!
  @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    testTextField.becomeFirstResponder()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: Notification selectors
  
  @objc func keyboardWillChangeFrame(notification: NSNotification) {
    guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
      return updateTextFieldPosition(forKeyboardHeight: 0.0)
    }
    updateTextFieldPosition(forKeyboardHeight: keyboardFrame.height)
  }
  
  @objc func keyboardWillHide() {
    updateTextFieldPosition(forKeyboardHeight: 0.0)
  }
  
  // MARK: Constants
  
  private func updateTextFieldPosition(forKeyboardHeight keyboardHeight: CGFloat) {
    let safeAreaHeight: CGFloat
    if keyboardHeight > 0.0 {
      safeAreaHeight = getSafeInsetBottomSize()
    } else {
      safeAreaHeight = 0.0
    }
    textFieldBottomConstraint.constant = keyboardHeight - safeAreaHeight
  }
  
  private func getSafeInsetBottomSize() -> CGFloat {
    if #available(iOS 11.0, *) {
      return view.window?.safeAreaInsets.bottom ?? 0.0
    }
    return 0.0
  }
  
}
