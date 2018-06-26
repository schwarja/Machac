//
//  RatioViewController.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

protocol RatioViewControllerDelegate: class {
    func didFinish(_ controller: RatioViewController, withRatio ratio: Ratio)
}

class RatioViewController: UITableViewController {
    
    let item: Item
    let ratio: Ratio?
    let people: Results<Person>
    
    private weak var delegate: RatioViewControllerDelegate?
    
    private var debtor: Person?
    private var value: Double?
    
    init(item: Item, omitPeople: [Person], delegate: RatioViewControllerDelegate, ratio: Ratio? = nil) {
        self.item = item
        self.ratio = ratio
        self.delegate = delegate
        self.people = RealmManager.shared.people(without: omitPeople)
        
        super.init(style: .grouped)
        
        self.debtor = ratio?.debtor ?? people.first
        self.value = ratio?.ratio
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let peopleCell = tableView.dequeueReusableCell(withIdentifier: PersonPickerCell.reuseIdentifier, for: indexPath) as! PersonPickerCell
            peopleCell.configure(withTitle: "Consumer", detail: ratio?.debtor?.name, values: people, selectedValue: debtor, valueChangedHandler: { [weak self] newValue in
                self?.debtor = newValue
            })
            peopleCell.isEditable = ratio == nil
            return peopleCell
            
        case 1:
            let valueCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as! TextFieldCell
            valueCell.configure(withPlaceholder: "Item ratio", text: value == nil ? nil : "\(value ?? 0)", keyboardType: .decimalPad, valueChangedHandler: { [weak self] newValue in
                self?.value = NumberFormatter().number(from: newValue)?.doubleValue ?? 0
            })
            return valueCell
            
        default:
            return UITableViewCell()
        }
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

private extension RatioViewController {
    
    func setupUI() {
        navigationItem.title = ratio == nil ? "Add Ratio" : "Update Ratio"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.saveRatio))
        if navigationController?.viewControllers.count == 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        }

        tableView.register(PersonPickerCell.self, forCellReuseIdentifier: PersonPickerCell.reuseIdentifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    @objc func saveRatio() {
        if let value = value, let debtor = debtor, value > 0 {
            let ratio = Ratio(item: item, debtor: debtor, ratio: value, id: self.ratio?.id)
            delegate?.didFinish(self, withRatio: ratio)
            cancel()
        }
        else {
            showMessage("Invalid input data")
        }
    }
}
