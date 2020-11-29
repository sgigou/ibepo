//
//  SwitchTableViewCell.swift
//  ibepo
//
//  Created by Steve Gigou on 29/11/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
  func didChange(id: String, newValue: Bool)
}

class SwitchTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueSwitch: UISwitch!

  private var id = ""
  private weak var delegate: SwitchTableViewCellDelegate?

  func configure(
    id: String,
    delegate: SwitchTableViewCellDelegate,
    title: String,
    isOn: Bool
  ) {
    self.delegate = delegate
    self.id = id
    titleLabel.text = title
    valueSwitch.isOn = isOn
  }

  @IBAction func switchValueDidChanged(_ sender: UISwitch) {
    delegate?.didChange(id: id, newValue: sender.isOn)
  }

}
