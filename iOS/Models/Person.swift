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
    
    var manager: RealmManager!
    
    var owes: Double {
        let people = manager.people(without: self)
        let sum = people.map({ self.owesTo(person: $0) }).reduce(0, { $0 + $1 })
        return sum
    }
    
    var isOwedTo: Double {
        let people = manager.people(without: self)
        let sum = people.map({ self.wantsFrom(person: $0) }).reduce(0, { $0 + $1 })
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
        let minus = consumedFrom(person: person)
        let plus = payedFor(person: person)
        return max(0, minus - plus)
    }
    
    func wantsFrom(person: Person) -> Double {
        let minus = consumedFrom(person: person)
        let plus = payedFor(person: person)
        return max(0, plus - minus)
    }
    
    func payedFor(person: Person) -> Double {
        let claims = manager.ratios(ownedBy: self, consumedBy: person)
        let plus = claims
            .map({ $0.ratio * ($0.item?.value(with: self.manager.settings.referenceCurrency) ?? 0) })
            .reduce(0, { $0 + $1 })
        return plus
    }
    
    func consumedFrom(person: Person) -> Double {
        let debts = manager.ratios(ownedBy: person, consumedBy: self)
        let minus = debts
            .map({ $0.ratio * ($0.item?.value(with: self.manager.settings.referenceCurrency) ?? 0) })
            .reduce(0, { $0 + $1 })
        return minus
    }
}

extension Person: CascadeDelete {
    
    func objectsToDelete() -> [Object] {
        var result: [Object] = []
        
        let debts = Array(self.ratios).flatMap({ $0.objectsToDelete() })
        let items = Array(self.items).flatMap({ $0.objectsToDelete() })
        
        result.append(contentsOf: debts)
        result.append(contentsOf: items)
        result.append(self)
        
        return result
    }
}

extension Person: ListableObject {
    
    var listTitle: String {
        return self.name
    }
}
