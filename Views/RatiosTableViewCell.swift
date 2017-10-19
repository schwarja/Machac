//
//  RatiosTableViewCell.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

protocol RatiosTableViewCellDelegate: class {
    func addRatio(_ cell: RatiosTableViewCell)
    func updateRatio(_ ratio: Ratio, cell: RatiosTableViewCell)
    func removeRatio(_ ratio: Ratio, cell: RatiosTableViewCell)
}

class RatiosTableViewCell: TableViewCell<Ratio> {
    
    weak var delegate: RatiosTableViewCellDelegate?
    
    func configure(source: [Ratio], delegate: RatiosTableViewCellDelegate) {
        self.delegate = delegate
        super.configure(source: source)
    }
    
    override func title(forValue value: Ratio) -> String? {
        return value.debtor?.name
    }
    
    override func detail(forValue value: Ratio) -> String? {
        return String(format: "%.2f", value.ratio)
    }
    
    override func addItem() {
        delegate?.addRatio(self)
    }
    
    override func updateItem(_ item: Ratio) {
        delegate?.updateRatio(item, cell: self)
    }
    
    override func removeItem(_ item: Ratio) {
        delegate?.removeRatio(item, cell: self)
    }
    
}
