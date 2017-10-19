//
//  DebtsViewController.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class DebtsViewController: UITableViewController {
    
    let claimer: Person
    let debtor: Person
    
    let ratios: Results<Ratio>
    
    init(claimer: Person, debtor: Person) {
        self.claimer = claimer
        self.debtor = debtor
        self.ratios = RealmManager.shared.ratios(ownedBy: claimer, consumedBy: debtor)
        
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
        return ratios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        let ratio = ratios[indexPath.row]
        cell.textLabel?.text = ratio.item?.name
        
        let currency = AppSettings.shared.referenceCurrency
        let owes = ratio.ratio * (ratio.item?.value ?? 0)
        cell.detailTextLabel?.text = "\(String(format: "%.2f", owes)) \(currency.code)"
        
        return cell
    }
    
}

private extension DebtsViewController {
    
    func setupUI() {
        navigationItem.title = "\(debtor.name) owes to \(claimer.name)"
        
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)
    }
}

