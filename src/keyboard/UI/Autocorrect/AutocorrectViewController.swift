//
//  AutocorrectViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 2020-05-20.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit


// MARK: - AutocorrectViewController

/// Manages autocorrect and displaying corrections.
class AutocorrectViewController: UIViewController {
  
  @IBOutlet weak var button1: UIButton!
  @IBOutlet weak var button2: UIButton!
  @IBOutlet weak var button3: UIButton!
  
  var delegate: KeyboardActionProtocol?
  
  /// Autocorrect engine.
  private let autocorrect = Autocorrect()
  
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    autocorrect.delegate = self
  }
  
  
  // MARK: User input
  
  /**
   The user tapped on the first correction.
   */
  @IBAction func button1Tap() {
    select(correction: autocorrect.correctionSet.correction1)
  }
  
  /**
   The user tapped on the second correction.
   */
  @IBAction func button2Tap() {
    select(correction: autocorrect.correctionSet.correction2)
  }
  
  /**
   The user tapped on the third correction.
   */
  @IBAction func button3Tap() {
    select(correction: autocorrect.correctionSet.correction3)
  }
  
  /**
   Replace the current word with the selected one.
   */
  private func select(correction: Correction?) {
    guard let correction = correction else { return }
    let analyzer = KeyboardSettings.shared.textDocumentProxyAnalyzer
    var shouldDelete = true
    if #available(iOS 11.0, *) {
      shouldDelete = analyzer.textDocumentProxy?.selectedText == nil
    }
    if shouldDelete {
      let currentWordCount = analyzer.currentWord.count
      delegate?.deleteBackward(amount: currentWordCount)
    }
    delegate?.insert(text: correction.word)
    delegate?.insert(text: " ")
  }
  
  
  // MARK: Updates
  
  /**
   Updates the corrections.
   
   - parameter text: The letter inserted by the user, if any.
   */
  func update(_ text: String? = nil) {
    autocorrect.update(text)
  }

}


// MARK: - AutocorrectProtocol

extension AutocorrectViewController: AutocorrectProtocol {
  
  func autocorrectEnded(with correctionSet: CorrectionSet) {
    DispatchQueue.main.sync {
      update(button: button1, with: correctionSet.correction1)
      update(button: button2, with: correctionSet.correction2)
      update(button: button3, with: correctionSet.correction3)
    }
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
