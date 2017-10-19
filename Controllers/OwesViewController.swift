//
//  OwesViewController.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class OwesViewController: UITableViewController {
    
    let person: Person
    let others: Results<Person>
    
    init(person: Person) {
        self.person = person
        self.others = RealmManager.shared.people(without: person)
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return others.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let person = others[indexPath.row]
        cell.textLabel?.text = person.name
        
        let currency = AppSettings.shared.referenceCurrency
        let owes = self.person.owesTo(person: person)
        cell.detailTextLabel?.text = "\(String(format: "%.2f", owes)) \(currency.code)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = others[indexPath.row]
        let controller = DebtsViewController(claimer: person, debtor: self.person)
        navigationController?.pushViewController(controller, animated: true)
    }

}

private extension OwesViewController {
    
    func setupUI() {
        navigationItem.title = "\(person.name) owes"
        
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)

    }
}
