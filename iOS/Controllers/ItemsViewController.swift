//
//  ItemsViewController.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsViewController: UITableViewController {
    var manager: RealmManager!

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
        notificationToken?.stop()
    }

    // MARK: TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let item = person.items[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = person.items[indexPath.row]
            manager.remove(object: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = person.items[indexPath.row]
        let controller = ItemViewController(item: item)
        navigationController?.pushViewController(controller, animated: true)
    }

}

private extension ItemsViewController {
    
    func setupUI() {
        navigationItem.title = "Items of \(person.name)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addItem))
        
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)
        
        notificationToken = person.items.addNotificationBlock({ [weak self] changes in
            switch changes {
            case .initial, .error:
                self?.tableView.reloadData()

            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.tableView.endUpdates()

            }
        })
    }
    
    @objc func addItem() {
        let controller = ItemViewController(person: person)
        navigationController?.pushViewController(controller, animated: true)
    }
}
