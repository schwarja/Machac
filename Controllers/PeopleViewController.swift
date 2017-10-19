//
//  MasterViewController.swift
//  Machac
//
//  Created by Jan on 17/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class PeopleViewController: UITableViewController {

    let people = RealmManager.shared.people
    var notificationToken: NotificationToken?
    
    private var nameTextField: UITextField?
    
    init() {
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

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator

        let person = people[indexPath.row]
        cell.textLabel!.text = person.name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = people[indexPath.row]
            RealmManager.shared.remove(object: person)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        let controller = PersonViewController(person: person)
        navigationController?.pushViewController(controller, animated: true)
    }

}

private extension PeopleViewController {
    
    func setupUI() {
        navigationItem.title = "People"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPerson))
        
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)
        
        notificationToken = people.observe { [weak self] changes in
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
        }
    }

    @objc func addPerson() {
        let alert = UIAlertController(title: "Enter name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            self.nameTextField = textField
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            if let name = self.nameTextField?.text {
                let person = Person(name: name)
                RealmManager.shared.insert(object: person)
            }
            self.nameTextField = nil
        }))
        present(alert, animated: true, completion: nil)
    }
}

