//
//  PickCurrencyCell.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import RealmSwift

class PickerViewCell<Value: Object>: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource where Value: ListableObject {
    
    private var changeHandler: ((Value) -> Void)?
    
    private var picker: UIPickerView!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private var pickerBottomConstraint: NSLayoutConstraint!
    
    private var source: Results<Value>?
    
    var isEditable: Bool = true
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        pickerBottomConstraint.isActive = selected && isEditable
        picker.isUserInteractionEnabled = selected && isEditable
    }
    
    var selectedValue: Value? {
        return source?[picker.selectedRow(inComponent: 0)]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func configure(withTitle title: String, detail: String? = nil, values: Results<Value>, selectedValue selected: Value? = nil, valueChangedHandler: ((Value) -> Void)? = nil) {
        self.source = values
        self.titleLabel.text = title
        self.changeHandler = valueChangedHandler
        picker.reloadAllComponents()
        
        if let selected = selected, let index = values.index(of: selected) {
            detailLabel.text = selected.listTitle
            picker.selectRow(index, inComponent: 0, animated: false)
        }
        else {
            detailLabel.text = detail ?? values.first?.listTitle
        }
    }
    
    func select(value: Value, animated: Bool = false) {
        if let index = source?.index(of: value) {
            picker.selectRow(index, inComponent: 0, animated: animated)
        }
    }
    
    @objc func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source?.count ?? 0
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let value = source?[row] {
            return title(forValue: value)
        }
        
        return nil
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let value = source?[row] {
            detailLabel.text = value.listTitle
            changeHandler?(value)
        }
    }
}

internal extension PickerViewCell {
    
    func setupUI() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
        contentView.addSubview(titleLabel)
        
        detailLabel = UILabel()
        detailLabel.setContentCompressionResistancePriority(UILayoutPriority(998), for: .horizontal)
        contentView.addSubview(detailLabel)
        
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addSubview(picker)
        
        picker.attach(left: 0, top: 30, right: 0)
        pickerBottomConstraint = NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        contentView.addConstraint(pickerBottomConstraint)
        NSLayoutConstraint.deactivate([pickerBottomConstraint])
        
        titleLabel.constraint(toHeight: 40)
        titleLabel.attach(left: 15, top: 0)
        titleLabel.attach(bottom: 0, priority: 750)
        
        detailLabel.constraint(toHeight: 40)
        detailLabel.attach(top: 0, right: 0)
        detailLabel.next(toView: titleLabel, constant: ">=10")

    }
    
    func title(forValue value: Value) -> String {
        return value.listTitle
    }
    
}
