//
//  AppSettings.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation

class AppSettings {
    
    static let shared = AppSettings()
    
    let currencies = RealmManager.shared.currencies
    private(set) var referenceCurrency: Currency
    
    init() {
        if let index = currencies.index(where: { $0.isReference }) {
            referenceCurrency = currencies[index]
        }
        else {
            let czk = Currency(code: Currency.defaultCode, relationToCzk: 1, isReference: true)
            RealmManager.shared.insert(object: czk)
            referenceCurrency = czk
        }
    }
    
    func initialize() {
        
    }
}
