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
    var manager: RealmManager!
    
    let claimer: Person
    let debtor: Person
    
    let debts: Results<Ratio>
    let claims: Results<Ratio>

    var notificationTokens = [NotificationToken]()

    init(claimer: Person, debtor: Person) {
        self.claimer = claimer
        self.debtor = debtor
        self.claims = manager.ratios(ownedBy: claimer, consumedBy: debtor)
        self.debts = manager.ratios(ownedBy: debtor, consumedBy: claimer)

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
        notificationTokens.forEach({ $0.stop() })
    }

    // MARK: TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return claims.count
            
        case 1:
            return debts.count
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        let ratio: Ratio
        switch indexPath.section {
        case 0:
            ratio = claims[indexPath.row]
            
        case 1:
            ratio = debts[indexPath.row]
            
        default:
            return cell
        }
        cell.textLabel?.text = ratio.item?.name
        
        let currency = manager.settings.referenceCurrency
        let owes = ratio.ratio * (ratio.item?.value(with: currency) ?? 0)
        cell.detailTextLabel?.text = "\(String(format: "%.2f", owes)) \(currency.code)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currency = manager.settings.referenceCurrency
        switch section {
        case 0:
            return "\(debtor.name) consumed \(String(format: "%.2f", debtor.consumedFrom(person: claimer))) \(currency.code)"
            
        case 1:
            return "\(debtor.name) payed \(String(format: "%.2f", debtor.payedFor(person: claimer))) \(currency.code)"
            
        default:
            return nil
        }
    }
    
}

private extension DebtsViewController {
    
    func setupUI() {
        navigationItem.title = "\(debtor.name) owes to \(claimer.name)"
        
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)
        
        notificationTokens.append(claims.addNotificationBlock { [weak self] _ in
            self?.tableView.reloadData()
        })
        
        notificationTokens.append(debts.addNotificationBlock { [weak self] _ in
            self?.tableView.reloadData()
        })
    }
}

