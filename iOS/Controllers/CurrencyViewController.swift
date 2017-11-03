//
//  CurrencyViewController.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit

class CurrencyViewController: UITableViewController {
    
    let currency: Currency?
    
    private var code: String?
    private var czkValue: Double?
    private var currencyValue: Double?
    
    init(currency: Currency?) {
        self.currency = currency
        
        if let cur = currency {
            self.code = cur.code
            self.czkValue = cur.relationToCzk
            self.currencyValue = 1
        }
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.currency = nil
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
        
        switch indexPath.section {
        case 0:
            cell.configure(withPlaceholder: "Currency Code", text: code, keyboardType: .default, valueChangedHandler: { [weak self] newCode in
                self?.code = newCode
            })
            
        case 1:
            cell.configure(withPlaceholder: "\(Currency.defaultCode) value", text: czkValue == nil ? nil : "\(czkValue ?? 0)", keyboardType: .decimalPad, valueChangedHandler: { [weak self] newValue in
                self?.czkValue = Double(newValue) ?? 0
            })
            
        case 2:
            cell.configure(withPlaceholder: "New currency value", text: currencyValue == nil ? nil : "\(currencyValue ?? 0)", keyboardType: .decimalPad, valueChangedHandler: { [weak self] newValue in
                self?.currencyValue = Double(newValue) ?? 0
            })
            
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Currency Code"
            
        case 1:
            return "Amount of \(Currency.defaultCode)"
            
        case 2:
            return "Equivalent to amount in the new currency"
            
        default:
            return nil
        }
    }

}

private extension CurrencyViewController {
    
    func setupUI() {
        navigationItem.title = currency == nil ? "Add item" : "Update item"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.saveCurrency))
        if navigationController?.viewControllers.count == 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        }

        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
    }
    
    @objc func saveCurrency() {
        if let code = code, let czkValue = czkValue, let currencyValue = currencyValue, !code.isEmpty && czkValue > 0 && currencyValue > 0 {
            let currency = Currency(code: code, relationToCzk: czkValue / currencyValue)
            if let error = RealmManager.shared.update(object: currency) {
                showMessage(error.localizedDescription)
            }
            else {
                cancel()
            }
        }
        else {
            showMessage("Invalid input data")
        }
    }
}
