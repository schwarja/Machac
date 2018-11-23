//
//  TextViewCell.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    private var textField: UITextField!
    private var valueChangedHandler: ((String) -> Void)?
    
    var string: String {
        return textField.text ?? ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func configure(withPlaceholder placeholder: String?, text: String? = nil, keyboardType: UIKeyboardType, valueChangedHandler: ((String) -> Void)? = nil) {
        textField.placeholder = placeholder
        textField.text = text
        textField.keyboardType = keyboardType
        self.valueChangedHandler = valueChangedHandler
    }

}

extension TextFieldCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        valueChangedHandler?(text)
        
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

internal extension TextFieldCell {
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .roundedRect
        contentView.addSubview(textField)
        
        textField.constraint(toHeight: 40)
        textField.attach(left: 15, top: 10, right: 15, bottom: 10)
    }
}
