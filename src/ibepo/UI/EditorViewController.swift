//
//  EditorViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 25/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!

  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    textView.delegate = self
    textView.inputAccessoryView = createToolbar()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setToolbarHidden(false, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setToolbarHidden(true, animated: animated)
  }

  // MARK: Drawing

  func createToolbar() -> UIToolbar {
    var toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: nil)
    var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: nil)
    var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
    return toolBar
  }

}

extension EditorViewController: UITextViewDelegate {



}
