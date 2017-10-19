//
//  TableViewCell.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewCell<T: Object>: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: TableViewWithUpdates!
    private var tableViewHeight: NSLayoutConstraint!
    
    private var source: [T] = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func configure(source: [T]) {
        self.source = source
        self.tableView.reloadData()
    }
    
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return source.count
            
        default:
            return 0
        }
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameValueCell.reuseIdentifier, for: indexPath) as! NameValueCell
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Add"
            
        case 1:
            let item = source[indexPath.row]
            cell.textLabel?.text = title(forValue: item)
            cell.detailTextLabel?.text = detail(forValue: item)

        default:
            break
        }
        
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            addItem()
            
        case 1:
            let item = source[indexPath.row]
            updateItem(item)
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    @objc func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let value = source[indexPath.row]
            removeItem(value)
        }
    }
    
    @objc func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    @objc func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: Interanl methods
    
    internal func title(forValue value: T) -> String? {
        return nil
    }
    
    internal func detail(forValue value: T) -> String? {
        return nil
    }
    
    internal func addItem() {
        
    }
    
    internal func updateItem(_ item: T) {
        
    }

    internal func removeItem(_ item: T) {
        
    }
}

extension TableViewCell: ScrollViewUpdateDelegate {
    
    func contentSizeDidChange(_ scrollView: UIScrollView, contentSize: CGSize) {
        tableViewHeight.constant = contentSize.height
    }
}

private extension TableViewCell {
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        tableView = TableViewWithUpdates()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.updateDelegate = self
        tableView.dataSource = self
        tableView.register(NameValueCell.self, forCellReuseIdentifier: NameValueCell.reuseIdentifier)
        contentView.addSubview(tableView)
        
        tableViewHeight = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        tableViewHeight.priority = UILayoutPriority(750)
        contentView.addConstraint(tableViewHeight)
        tableView.attach(left: 0, top: 0, right: 0, bottom: 0)
    }
}
