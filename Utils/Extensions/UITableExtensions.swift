//
//  UITableExtensions.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    class var reuseIdentifier: String {
        
        return NSStringFromClass(self) + "Identifier"
    }
    
}

extension UITableViewHeaderFooterView {
    
    class var reuseIdentifier: String {
        
        return NSStringFromClass(self) + "Identifier"
    }
}

extension UICollectionReusableView {
    
    class var reuseIdentifier: String {
        
        return NSStringFromClass(self) + "Identifier"
    }
}
