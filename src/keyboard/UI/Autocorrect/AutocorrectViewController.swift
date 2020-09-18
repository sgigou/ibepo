//
//  AutocorrectViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-20.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - AutocorrectViewController

/// Autocorrect suggestions bar
final class AutocorrectViewController: UIViewController {
  
  @IBOutlet weak var button1: UIButton!
  @IBOutlet weak var button2: UIButton!
  @IBOutlet weak var button3: UIButton!
  
  weak var delegate: KeyboardActionProtocol?
  
  let autocorrectEngine = Autocorrect()
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    autocorrectEngine.delegate = self
    setupButtons()
  }
  
  // MARK: Setup
  
  private func setupButtons() {
    // The background color is not set to clear to allow a tap on the whole surface of the button.
    button1.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.001)
    button2.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.001)
    button3.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.001)
  }
  
  
  // MARK: User input
  
  @IBAction func button1Tap() {
    select(correction: autocorrectEngine.correctionSet.correction1)
  }
  
  @IBAction func button2Tap() {
    select(correction: autocorrectEngine.correctionSet.correction2)
  }
  
  @IBAction func button3Tap() {
    select(correction: autocorrectEngine.correctionSet.correction3)
  }
  
  private func select(correction: Correction?) {
    guard let correction = correction else { return }
    let analyzer = KeyboardSettings.shared.textDocumentProxyAnalyzer
    var amountToDelete = analyzer.currentWord.count
    if #available(iOS 11.0, *) {
      amountToDelete = analyzer.textDocumentProxy?.selectedText != nil ? 0 : amountToDelete
    }
    let nextCharacter = analyzer.textDocumentProxy?.documentContextAfterInput?.first
    let isInsertingBeforeSpace = [" ", " "].contains(nextCharacter)
    let separator = isInsertingBeforeSpace ? "" : " "
    delegate?.replace(charactersAmount: amountToDelete, by: correction.word, separator: separator)
    if isInsertingBeforeSpace {
      delegate?.moveCursor(by: 1)
    }
    NotificationCenter.default.post(name: .userSelectedASuggestion, object: nil)
  }

}


// MARK: - AutocorrectProtocol

extension AutocorrectViewController: AutocorrectProtocol {
  
  func autocorrectEnded(with correctionSet: CorrectionSet) {
    update(button: button1, with: correctionSet.correction1)
    update(button: button2, with: correctionSet.correction2)
    update(button: button3, with: correctionSet.correction3)
  }
  
  private func update(button: UIButton, with correction: Correction?) {
    if let correction = correction {
      button.setTitle(correction.exists ? correction.word : "« \(correction.word) »", for: .normal)
      button.setTitleColor(correction.isPreferred ? ColorManager.shared.mainColor : ColorManager.shared.label, for: .normal)
    } else {
      button.setTitle(nil, for: .normal)
    }
  }
  
}
