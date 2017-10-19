//
//  Item.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Item: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var owner: Person?
    @objc dynamic var valueInCurrency: Double = 0
    @objc dynamic var currency: Currency?
    let ratios = LinkingObjects(fromType: Ratio.self, property: "item")
    
    var value: Double {
        let czkValue = valueInCurrency * (currency?.relationToCzk ?? 0)

        if AppSettings.shared.referenceCurrency.isDefault {
            return czkValue
        }
        else {
            return czkValue / AppSettings.shared.referenceCurrency.relationToCzk
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(name: String, owner: Person, valueInCurrency: Double, currency: Currency, id: String? = nil) {
        self.id = id ?? NSUUID().uuidString
        self.name = name
        self.owner = owner
        self.valueInCurrency = valueInCurrency
        self.currency = currency
        
        super.init()
    }
    
    required init() {
        self.id = NSUUID().uuidString
        
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

extension Item: CascadeDelete {
    
    func objectsToDelete() -> [Object] {
        var result: [Object] = []
        
        let ratios = Array(self.ratios)
        result.append(contentsOf: ratios as [Object])
        
        result.append(self)
        
        return result
    }
}
