//
//  ItemOwnerViewController.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class ItemOwnerViewController: UITableViewController {
    
    let people = RealmManager.shared.people
    
    private var owner: Person?
    
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
    
    // MARK: TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let peopleCell = tableView.dequeueReusableCell(withIdentifier: PersonPickerCell.reuseIdentifier, for: indexPath) as! PersonPickerCell
            peopleCell.configure(withTitle: "Owner", values: people, selectedValue: owner, valueChangedHandler: { [weak self] newValue in
                self?.owner = newValue
            })
            return peopleCell
            
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

private extension ItemOwnerViewController {
    
    func setupUI() {
        navigationItem.title = "Select item owner"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.selectOwner))
        if navigationController?.viewControllers.count == 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        }
        
        tableView.register(PersonPickerCell.self, forCellReuseIdentifier: PersonPickerCell.reuseIdentifier)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    @objc func selectOwner() {
        if let owner = owner {
            let controller = ItemViewController(person: owner, shouldDismiss: true)
            navigationController?.pushViewController(controller, animated: true)
        }
        else {
            showMessage("Invalid input data")
        }
    }
}

