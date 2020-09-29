//
//  EditorViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 25/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

  static let userDefaultsTextKey = "editorText"

  @IBOutlet weak var textView: UITextView!

  private let deadKeyConverter = DeadKeyConverter()

  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    observeNotifications()
    textView.inputAccessoryView = createToolbar()
    load()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textView.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    textView.resignFirstResponder()
    NotificationCenter.default.removeObserver(self)
    persist()
  }

  // MARK: Notifications

  private func observeNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameDidChange(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(persist), name: .applicationWillResignActive, object: nil)
  }

  // MARK: Drawing

  func createToolbar() -> UIToolbar {
    let toolBar = UIToolbar()
    let deleteButton = UIBarButtonItem(image: UIImage(named: "trash-2"), style: .plain, target: self, action: #selector(deleteText(_:)))
    deleteButton.tintColor = .systemRed
    let pasteButton = UIBarButtonItem(image: UIImage(named: "clipboard"), style: .plain, target: self, action: #selector(pasteText(_:)))
    pasteButton.tintColor = .systemRed
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let copyButton = UIBarButtonItem(image: UIImage(named: "copy"), style: .plain, target: self, action: #selector(copyText(_:)))
    toolBar.setItems([deleteButton, pasteButton, spaceButton, copyButton], animated: false)
    toolBar.sizeToFit()
    return toolBar
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

  // MARK: Persistence

  @objc func persist() {
    UniversalLogger.debug("Persisting changes")
    UserDefaults.standard.setValue(textView.text, forKey: EditorViewController.userDefaultsTextKey)
  }

  private func load() {
    UniversalLogger.debug("Loading changes")
    textView.text = UserDefaults.standard.string(forKey: EditorViewController.userDefaultsTextKey)
  }

  // MARK: User interaction

  @IBAction func displayHelp(_ sender: Any) {
    let alert = UIAlertController(title: "Éditeur pour clavier physique", message: "Cet éditeur permet de taper en bépo avec un clavier physique.\nLes boutons situés au-dessus du clavier vous permettent de rapidement supprimer, coller et copier l’ensemble du texte saisi.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Fermer", style: .default, handler: nil))
    present(alert, animated: true)
  }

  @objc func deleteText(_ sender: UIBarButtonItem) {
    if !textView.text.isEmpty {
      let alert = UIAlertController(title: "Effacer le texte", message: "Souhaitez-vous réellement effacer le texte saisi ?", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive, handler: {
        [weak self] _ in
        self?.textView.text = ""
      }))
      if let popoverController = alert.popoverPresentationController {
        popoverController.barButtonItem = sender
      }
      present(alert, animated: true)
    }
  }

  @objc func pasteText(_ sender: UIBarButtonItem) {
    if textView.text.isEmpty {
      textView.text = UIPasteboard.general.string
    } else {
      let alert = UIAlertController(title: "Coller le texte", message: "Souhaitez-vous réellement remplacer le text par le contenu du presse-papier ?", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Coller", style: .destructive, handler: {
        [weak self] _ in
        self?.textView.text = UIPasteboard.general.string
      }))
      if let popoverController = alert.popoverPresentationController {
        popoverController.barButtonItem = sender
      }
      present(alert, animated: true)
    }
  }

  @objc func copyText(_ sender: UIBarButtonItem) {
    UIPasteboard.general.string = textView.text
    sender.tintColor = .systemGreen
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      sender.tintColor = .systemBlue
    }
  }

  // MARK: Bépo conversion

  override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    if #available(iOS 13.4, *) {
      guard let key = presses.first?.key else {
        return super.pressesBegan(presses, with: event)
      }
      print(key.keyCode.rawValue)
      guard var character = BepoKeymap.getEquivalentChar(for: key) else {
        return super.pressesBegan(presses, with: event)
      }
      if character.isEmpty { return }
      if let markedTextRange = textView.markedTextRange,
         let markedText = textView.text(in: markedTextRange) {
        if deadKeyConverter.shouldEscape(markedText: markedText, with: character) {
          textView.insertText(markedText)
          return
        }
        character = deadKeyConverter.combine(markedText: markedText, with: character)
      }
      if !deadKeyConverter.isModificativeLetter(character) {
        textView.insertText(character)
      } else {
        character = " \(character)"
        textView.setMarkedText(character, selectedRange: NSRange(location: 0, length: character.count))
      }
    } else {
      return super.pressesBegan(presses, with: event)
    }
  }

}
