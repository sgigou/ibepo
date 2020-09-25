//
//  LandingViewController.swift
//  ibepo
//
//  Created by Steve Gigou on 25/09/2020.
//  Copyright © 2020 Novesoft. All rights reserved.
//

import UIKit

class LandingViewController: UITableViewController {

  enum Sections: Int, CaseIterable {
    case tools, help, links, contact
  }

  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableHeaderView = Bundle.main.loadNibNamed("LandingHeaderView", owner: nil, options: nil)?.first as? UIView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  // MARK: Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allCases.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case Sections.tools.rawValue: return "Outils"
    case Sections.help.rawValue: return "Aide"
    case Sections.links.rawValue: return "Liens utiles"
    case Sections.contact.rawValue: return "Contact"
    default: return ""
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case Sections.tools.rawValue: return 1
    case Sections.help.rawValue: return 2
    case Sections.links.rawValue: return 2
    case Sections.contact.rawValue: return 1
    default: return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
    switch indexPath.section {
    case Sections.tools.rawValue:
      configure(cell, title: "Éditeur pour clavier physique", imageName: "command")
    case Sections.help.rawValue:
      switch indexPath.row {
      case 0: configure(cell, title: "Installation", imageName: "settings")
      case 1: configure(cell, title: "Documentation", imageName: "book-open")
      default: break
      }
    case Sections.links.rawValue:
      switch indexPath.row {
      case 0: configure(cell, title: "Site de la disposition Bépo", imageName: "globe")
      case 1: configure(cell, title: "Site du projet iBépo", imageName: "github")
      default: break
      }
    case Sections.contact.rawValue:
      configure(cell, title: "Contactez-moi", imageName: "twitter")
    default:
      break
    }
    return cell
  }

  private func configure(_ cell: UITableViewCell, title: String, imageName: String) {
    cell.textLabel?.text = title
    cell.imageView?.image = UIImage(named: imageName)
    if #available(iOS 13.0, *) {
      cell.imageView?.tintColor = .tertiaryLabel
    } else {
      cell.imageView?.tintColor = .systemGray
    }
  }

  // MARK: User interaction

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case Sections.help.rawValue:
      switch indexPath.row {
      case 0: open(segue: "install")
      case 1: open(url: "https://github.com/sgigou/ibepo/wiki")
      default: break
      }
    case Sections.links.rawValue:
      switch indexPath.row {
      case 0: open(url: "https://bepo.fr")
      case 1: open(url: "https://github.com/sgigou/ibepo")
      default: break
      }
    case Sections.contact.rawValue: open(url: "https://twitter.com/stevegigou")
    default: break
    }
  }

  private func open(url destination: String) {
    guard let url = URL(string: destination) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.openURL(url)
    }
  }

  private func open(segue identifier: String) {
    performSegue(withIdentifier: identifier, sender: self)
  }

}
