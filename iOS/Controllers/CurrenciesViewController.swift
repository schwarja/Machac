//
//  CurrenciesViewController.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class CurrenciesViewController: UITableViewController {
    
    let currencies = RealmManager.shared.currencies
    
    var notificationToken: NotificationToken?

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
        notificationToken?.stop()
    }

    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath)
        let currency = currencies[indexPath.row]
        cell.textLabel?.text = currency.code
        cell.detailTextLabel?.text = "1 \(currency.code) = \(String(format: "%.2f", currency.relationToCzk)) \(Currency.defaultCode)"
        
        cell.accessoryType = currency.isDefault ? .none : .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let currency = currencies[indexPath.row]
        return !currency.isDefault && !currency.isReference
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currency = currencies[indexPath.row]
            RealmManager.shared.remove(object: currency)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
        if !currency.isDefault {
            presentCurrencyController(withCurrency: currency)
        }
        else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}

private extension CurrenciesViewController {
    
    func setupUI() {
        navigationItem.title = "Currencies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addCurrency))
        
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)
        
        notificationToken = currencies.addNotificationBlock { [weak self] changes in
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
    
    @objc func addCurrency() {
        presentCurrencyController()
    }
    
    func presentCurrencyController(withCurrency currency: Currency? = nil) {
        let controller = CurrencyViewController(currency: currency)
        navigationController?.pushViewController(controller, animated: true)
    }
}
