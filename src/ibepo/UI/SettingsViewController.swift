//
//  SettingsViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 29/11/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

  enum CellId: String {
    case SecondaryLetters
  }

  enum Row: Int {
    case SecondaryLetters
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchTableViewCell")
  }

  // MARK: Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.row) {
    case Row.SecondaryLetters.rawValue: // Secondary letters
      let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
      cell.configure(id: CellId.SecondaryLetters.rawValue, delegate: self, title: "Afficher les lettres secondaires", isOn: true)
      return cell
    default:
      fatalError("Row not found")
    }
  }

}

extension SettingsViewController: SwitchTableViewCellDelegate {

  func didChange(id: String, newValue: Bool) {
    switch id {
    case CellId.SecondaryLetters.rawValue:
    default:
      fatalError("Unhandled change function")
    }
  }

}
