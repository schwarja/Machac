//
//  UIViewExtension.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit

protocol LayoutSpecifier {
    
    var layoutRelation: NSLayoutRelation { get }
    var layoutConstant: CGFloat { get }
}

extension Double: LayoutSpecifier {
    
    var layoutRelation: NSLayoutRelation {
        return .equal
    }
    
    var layoutConstant: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat: LayoutSpecifier {
    
    var layoutRelation: NSLayoutRelation {
        return .equal
    }
    
    var layoutConstant: CGFloat {
        return self
    }
}

extension Int: LayoutSpecifier {
    
    var layoutRelation: NSLayoutRelation {
        return .equal
    }
    
    var layoutConstant: CGFloat {
        return CGFloat(self)
    }
}

extension String: LayoutSpecifier {
    
    var layoutConstant: CGFloat {
        let numberString: String
        
        if layoutRelation == .equal {
            numberString = self
        }
        else if self.count > 2 {
            numberString = String(self[self.index(self.startIndex, offsetBy: 2)...])
        }
        else {
            numberString = ""
        }
        
        if let number = NumberFormatter().number(from: numberString) {
            return CGFloat(number.floatValue)
        }
        else {
            return 0.0
        }
    }
    
    var layoutRelation: NSLayoutRelation {
        if hasPrefix(">=") {
            return .greaterThanOrEqual
        }
        else if hasPrefix("<=") {
            return .lessThanOrEqual
        }
        else {
            return .equal
        }
    }
    
}

extension UIView {
    
    func findTopConstraint() -> NSLayoutConstraint? {
        for constraint in superview?.constraints ?? [] {
            if isTopConstraint(constraint) {
                return constraint
            }
        }
        
        return nil
    }
    
    func isTopConstraint(_ constraint: NSLayoutConstraint) -> Bool {
        if constraint.firstItem as? UIView == self && constraint.firstAttribute == .top {
            return true
        }
        else if constraint.secondItem as? UIView == self && constraint.secondAttribute == .top {
            return true
        }
        else {
            return false
        }
    }
    
    func constraint(toWidth width: LayoutSpecifier? = nil, toHeight height: LayoutSpecifier? = nil, priority: Float = 1000) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: width.layoutRelation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            addConstraint(constraint)
        }
        
        if let height = height {
            let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: height.layoutRelation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            addConstraint(constraint)
        }
    }
    
    func constraint(width: LayoutSpecifier? = nil, height: LayoutSpecifier? = nil, toView view: UIView, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: width.layoutRelation, toItem: view, attribute: .width, multiplier: 1, constant: width.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
        
        if let height = height {
            let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: height.layoutRelation, toItem: view, attribute: .height, multiplier: 1, constant: height.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
    }
    
    func constraint(toAspectRatio ratio: CGFloat, priority: Float = 1000) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0)
        constraint.priority = UILayoutPriority(priority)
        addConstraint(constraint)
    }
    
    func attach(toView view: UIView? = nil, left: LayoutSpecifier? = nil, top: LayoutSpecifier? = nil, right: LayoutSpecifier? = nil, bottom: LayoutSpecifier? = nil, priority: Float = 1000) {
        guard let view = view ?? self.superview else {
            return
        }
        
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let left = left {
            let constraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: left.layoutRelation, toItem: view, attribute: .left, multiplier: 1, constant: left.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
        
        if let top = top {
            let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: top.layoutRelation, toItem: view, attribute: .top, multiplier: 1, constant: top.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
        
        if let right = right {
            let constraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: right.layoutRelation, toItem: self, attribute: .right, multiplier: 1, constant: right.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
        
        if let bottom = bottom {
            let constraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: bottom.layoutRelation, toItem: self, attribute: .bottom, multiplier: 1, constant: bottom.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
    }
    
    func attach(toView view: UIView? = nil, centerX: LayoutSpecifier? = nil, centerY: LayoutSpecifier? = nil) {
        guard let view = view ?? self.superview else {
            return
        }
        
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: centerX.layoutRelation, toItem: view, attribute: .centerX, multiplier: 1, constant: centerX.layoutConstant))
        }
        
        if let centerY = centerY {
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: centerY.layoutRelation, toItem: view, attribute: .centerY, multiplier: 1, constant: centerY.layoutConstant))
        }
    }
    
    func next(toView view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: constant.layoutRelation, toItem: view, attribute: .right, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
    }
    
    func below(view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: constant.layoutRelation, toItem: view, attribute: .bottom, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
    }
    
    func before(view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: constant.layoutRelation, toItem: self, attribute: .right, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
    }
    
    func above(view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: constant.layoutRelation, toItem: self, attribute: .bottom, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
    }
}
