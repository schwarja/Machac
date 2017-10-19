//
//  Ratio.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Ratio: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var item: Item?
    @objc dynamic var debtor: Person?
    @objc dynamic var ratio: Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(item: Item, debtor: Person, ratio: Double, id: String? = nil) {
        self.id = id ?? NSUUID().uuidString
        self.item = item
        self.debtor = debtor
        self.ratio = ratio
        
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

extension Ratio: CascadeDelete {
    
    func objectsToDelete() -> [Object] {
        var result: [Object] = []
        
        result.append(self)
        
        return result
    }
}
