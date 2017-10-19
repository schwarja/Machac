//
//  PersonViewController.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class PersonViewController: UITableViewController {
    
    let person: Person
    var notificationToken: NotificationToken?

    init(person: Person) {
        self.person = person
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    deinit {
        notificationToken?.invalidate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Owes"
            cell.detailTextLabel?.text = "\(person.owes) \(AppSettings.shared.referenceCurrency.code)"
            
        case 1:
            cell.textLabel?.text = "Is owed to \(person.name)"
            cell.detailTextLabel?.text = "\(person.isOwedTo) \(AppSettings.shared.referenceCurrency.code)"

        case 2:
            cell.textLabel?.text = "Items"
            cell.detailTextLabel?.text = "\(person.items.count)"

        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controller = OwesViewController(person: person)
            navigationController?.pushViewController(controller, animated: true)

        case 1:
            let controller = IsOwedViewController(person: person)
            navigationController?.pushViewController(controller, animated: true)

        case 2:
            let controller = ItemsViewController(person: person)
            navigationController?.pushViewController(controller, animated: true)
            
        default:
            break
        }
    }
}

private extension PersonViewController {
    
    func setupUI() {
        navigationItem.title = person.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(self.export))
        
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)
        
        notificationToken = person.items.observe { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    @objc func export() {
        do {
            if let url = try ExportManager.shared.exportCosts(forPerson: person) {
                let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                present(controller, animated: true, completion: nil)
            }
        }
        catch let error {
            showMessage(error.localizedDescription)
        }
    }
}
