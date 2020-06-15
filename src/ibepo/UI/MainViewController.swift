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

}


// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
