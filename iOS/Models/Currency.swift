//
//  Currency.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Currency: Object {
    static let defaultCode = "CZK"
    
    @objc dynamic var code: String = ""
    @objc dynamic var relationToCzk: Double = 0
    @objc dynamic var isReference: Bool = false
    
    var isDefault: Bool {
        return code == Currency.defaultCode
    }

    override static func primaryKey() -> String? {
        return "code"
    }
    
    init(code: String, relationToCzk: Double, isReference: Bool = false) {
        self.code = code
        self.relationToCzk = relationToCzk
        self.isReference = isReference
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

extension Currency: CascadeDelete {
    
    func beforeDelete(manager: RealmManager) {
        let items = manager.items(inCurrency: self)
        var updatedObjects: [Object] = []
        
        for item in items {
            guard let owner = item.owner else {
                continue
            }
            let newValue = item.value(with: manager.settings.referenceCurrency)
            
            let updateItem = Item(name: item.name, owner: owner, valueInCurrency: newValue, currency: manager.settings.referenceCurrency, id: item.id)
            
            for ratio in item.ratios {
                guard let debtor = ratio.debtor else {
                    continue
                }
                
                let updatedRatio = Ratio(item: updateItem, debtor: debtor, ratio: ratio.ratio, id: ratio.id)
                updatedObjects.append(updatedRatio)
            }
            
            updatedObjects.append(updateItem)
        }
        
        updatedObjects.forEach({ manager.update(object: $0) })
    }
    
    func objectsToDelete() -> [Object] {
        var result: [Object] = []
        
        result.append(self)
        
        return result
    }
}

extension Currency: ListableObject {
    
    var listTitle: String {
        return self.code
    }
}
