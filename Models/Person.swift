//
//  Person.swift
//  Machac
//
//  Created by Jan on 17/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Person: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    let items = LinkingObjects(fromType: Item.self, property: "owner")
    let ratios = LinkingObjects(fromType: Ratio.self, property: "debtor")
    
    var owes: Double {
        let ratios = RealmManager.shared.ratios(consumedBy: self)
        let sum = ratios.map({ $0.ratio * ($0.item?.value ?? 0) }).reduce(0, { $0 + $1 })
        return sum
    }
    
    var isOwedTo: Double {
        let ratios = RealmManager.shared.ratios(ownedBy: self)
        let sum = ratios.map({ $0.ratio * ($0.item?.value ?? 0) }).reduce(0, { $0 + $1 })
        return sum
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(name: String) {
        self.id = NSUUID().uuidString
        self.name = name
        
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
    
    func owesTo(person: Person) -> Double {
        let ratios = RealmManager.shared.ratios(ownedBy: person, consumedBy: self)
        let sum = ratios.map({ $0.ratio * ($0.item?.value ?? 0) }).reduce(0, { $0 + $1 })
        return sum
    }
    
    func wantsFrom(person: Person) -> Double {
        let ratios = RealmManager.shared.ratios(ownedBy: self, consumedBy: person)
        let sum = ratios.map({ $0.ratio * ($0.item?.value ?? 0) }).reduce(0, { $0 + $1 })
        return sum
    }
}

extension Person: CascadeDelete {
    
    func objectsToDelete() -> [Object] {
        var result: [Object] = []
        
        let debts = Array(self.ratios)
        result.append(contentsOf: debts as [Object])
        
        let items = Array(self.items)
        let claims = items.flatMap({ Array($0.ratios) })
        result.append(contentsOf: claims as [Object])
        result.append(contentsOf: items as [Object])
        
        result.append(self)
        
        return result
    }
}

extension Person: ListableObject {
    
    var listTitle: String {
        return self.name
    }
}
