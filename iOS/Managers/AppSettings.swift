//
//  AppSettings.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation

class AppSettings {
    private(set) var referenceCurrency: Currency
    
    init() {
            let czk = Currency(code: Currency.defaultCode, relationToCzk: 1, isReference: true)
            referenceCurrency = czk
    }
    
    func updateReferenceCurrency(with currency: Currency) {
        self.referenceCurrency = currency
    }
}
