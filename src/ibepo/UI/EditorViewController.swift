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
    observeKeyboardNotifications()
    textView.delegate = self
    textView.inputAccessoryView = createToolbar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textView.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    textView.resignFirstResponder()
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Drawing

  func createToolbar() -> UIToolbar {
    let toolBar = UIToolbar()
    let deleteButton = UIBarButtonItem(image: UIImage(named: "trash-2"), style: .plain, target: nil, action: nil)
    deleteButton.tintColor = .systemRed
    let pasteButton = UIBarButtonItem(image: UIImage(named: "clipboard"), style: .plain, target: nil, action: nil)
    pasteButton.tintColor = .systemRed
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let copyButton = UIBarButtonItem(image: UIImage(named: "copy"), style: .plain, target: nil, action: nil)
    toolBar.setItems([deleteButton, pasteButton, spaceButton, copyButton], animated: false)
    toolBar.sizeToFit()
    return toolBar
  }

  // MARK: Keyboard

  private func observeKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameDidChange(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
  }

  @objc func keyboardFrameDidChange(_ notification: NSNotification) {
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
    var safeAreaBottom: CGFloat = 0.0
    if #available(iOS 11.0, *) {
      safeAreaBottom = view.safeAreaInsets.bottom
    }
    let bottomInset = keyboardSize.height - safeAreaBottom
    let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
    textView.contentInset = contentInset
    textView.scrollIndicatorInsets = contentInset
    textView.scrollRangeToVisible(textView.selectedRange)
  }

  // MARK: User interaction

  @IBAction func displayHelp(_ sender: Any) {
    let alert = UIAlertController(title: "Éditeur pour clavier physique", message: "Cet éditeur permet de taper en bépo avec un clavier physique.\nLes boutons situés au-dessus du clavier vous permettent de rapidement supprimer, coller et copier l’ensemble du texte saisi.\n\nAssurez-vous que votre clavier est sur la disposition Français (France).", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Fermer", style: .default, handler: nil))
    self.present(alert, animated: true)
  }

}

extension EditorViewController: UITextViewDelegate {



}
