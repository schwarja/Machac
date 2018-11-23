//
//  AddItemViewController.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    let shouldDismiss: Bool
    
    let owner: Person
    let item: Item
    private var ratios: [Ratio]
    private var originalRatios: [Ratio]
    
    var manager: RealmManager!
    
    let currencies: Results<Currency>
    
    private var name = ""
    private var currency: Currency!
    private var value: Double?
    
    init(item: Item, shouldDismiss: Bool = false) {
        self.shouldDismiss = shouldDismiss
        
        self.owner = item.owner!
        self.item = item
        self.ratios = manager.ratios(ofItem: item)
        self.originalRatios = ratios
        
        self.name = item.name
        self.value = item.valueInCurrency
        if let currency = item.currency {
            self.currency = currency
        }
        self.currencies = manager.currencies
        
        super.init(style: .grouped)
        
        setupUI()
    }

    init(person: Person, shouldDismiss: Bool = false) {
        self.shouldDismiss = shouldDismiss

        self.owner = person
        self.item = Item()
        self.ratios = []
        self.originalRatios = []
        self.currencies = manager.currencies

        super.init(style: .grouped)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let nameCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            nameCell.configure(withPlaceholder: "Item name", text: name, keyboardType: .default, valueChangedHandler: { [weak self] newName in
                self?.name = newName
            })
            return nameCell

        case 1:
            let valueCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            valueCell.configure(withPlaceholder: "Item value", text: value == nil ? nil : "\(value ?? 0)", keyboardType: .decimalPad, valueChangedHandler: { [weak self] newValue in
                self?.value = NumberFormatter().number(from: newValue)?.doubleValue ?? 0
            })
            return valueCell
            
        case 2:
            let currencyCell = tableView.dequeueReusableCell(withIdentifier: CurrencyPickerCell.reuseIdentifier, for: indexPath) as! CurrencyPickerCell
            currencyCell.configure(withTitle: "Currency", values: currencies, selectedValue: currency, valueChangedHandler: { [weak self] currency in
                self?.currency = currency
            })
            return currencyCell
            
        case 3:
            let ratiosCell = tableView.dequeueReusableCell(withIdentifier: RatiosTableViewCell.reuseIdentifier, for: indexPath) as! RatiosTableViewCell
            ratiosCell.configure(source: ratios, delegate: self)
            return ratiosCell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
            
        case 1:
            return "Value"
            
        case 2:
            return "Currency"
            
        case 3:
            return "Consumers"
            
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.beginUpdates()
            tableView.endUpdates()
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension ItemViewController: RatiosTableViewCellDelegate {
    
    func addRatio(_ cell: RatiosTableViewCell) {
        presentRatioViewController()
    }
    
    func updateRatio(_ ratio: Ratio, cell: RatiosTableViewCell) {
        presentRatioViewController(withRatio: ratio)
    }
    
    func removeRatio(_ ratio: Ratio, cell: RatiosTableViewCell) {
        if let index = ratios.index(of: ratio) {
            ratios.remove(at: index)
        }
        tableView.reloadData()
    }
    
    func presentRatioViewController(withRatio ratio: Ratio? = nil) {
        var omit = ratios.compactMap({ $0.debtor })
        omit.append(owner)
        let controller = RatioViewController(item: item, omitPeople: omit, delegate: self, ratio: ratio)
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension ItemViewController: RatioViewControllerDelegate {
    
    func didFinish(_ controller: RatioViewController, withRatio ratio: Ratio) {
        if let index = ratios.index(where: { $0.id == ratio.id }) {
            ratios.remove(at: index)
            ratios.insert(ratio, at: index)
        }
        else {
            ratios.append(ratio)
        }
        
        tableView.reloadData()
    }
}

private extension ItemViewController {
    
    func setupUI() {
        navigationItem.title = item.owner == nil ? "Add item" : "Update item"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.saveItem))
        if navigationController?.viewControllers.count == 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        }
        
        tableView.register(CurrencyPickerCell.self, forCellReuseIdentifier: CurrencyPickerCell.reuseIdentifier)
        tableView.register(PersonPickerCell.self, forCellReuseIdentifier: PersonPickerCell.reuseIdentifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(RatiosTableViewCell.self, forCellReuseIdentifier: RatiosTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 6010
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func saveItem() {
        if let value = value, !name.isEmpty && value > 0 {
            let item = Item(name: name, owner: owner, valueInCurrency: value, currency: currency, id: self.item.id)
            if let error = manager.update(object: item) {
                showMessage(error.localizedDescription)
            }
            else if let error = saveRatios(forItem: item) {
                showMessage(error.localizedDescription)
            }
            else {
                popOrDismiss()
            }
        }
        else {
            showMessage("Invalid input data")
        }
    }
    
    func saveRatios(forItem item: Item) -> Error? {
        for ratio in ratios {
            let updatedRatio = Ratio(item: item, debtor: ratio.debtor!, ratio: ratio.ratio, id: ratio.id)
            if let error = manager.update(object: updatedRatio) {
                return error
            }
        }
        for ratio in originalRatios where !ratios.contains(where: { $0.id == ratio.id}) {
            manager.remove(object: ratio)
        }
        
        return nil
    }
    
    @objc func popOrDismiss() {
        if shouldDismiss {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
}
