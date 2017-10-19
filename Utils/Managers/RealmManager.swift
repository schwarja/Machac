//
//  RealmManager.swift
//  Machac
//
//  Created by Jan on 17/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    // MARK: People
    
    var people: Results<Person> {
        return realm.objects(Person.self).sorted(byKeyPath: "name")
    }
    
    func people(without person: Person) -> Results<Person> {
        return realm.objects(Person.self).filter("id != '\(person.id)'").sorted(byKeyPath: "name")
    }
    
    func people(without people: [Person]) -> Results<Person> {
        return realm.objects(Person.self).filter("NOT (id IN %@)", people.map({ $0.id })).sorted(byKeyPath: "name")
    }

    func person(withId id: String) -> Results<Person> {
        return realm.objects(Person.self).filter("id == '\(id)'")
    }

    // MARK: Items
    
    func items(inCurrency currency: Currency) -> Results<Item> {
        return realm.objects(Item.self).filter("currency == %@", currency)
    }
    
    // MARK: Ratios
    
    func ratios(ownedBy owner: Person) -> Results<Ratio> {
        return realm.objects(Ratio.self).filter("item.owner == %@", owner)
    }
    
    func ratios(consumedBy consumer: Person) -> Results<Ratio> {
        return realm.objects(Ratio.self).filter("debtor == %@", consumer)
    }

    func ratios(ownedBy owner: Person, consumedBy consumer: Person) -> Results<Ratio> {
        return realm.objects(Ratio.self).filter("item.owner == %@ AND debtor == %@", owner, consumer)
    }
    
    func ratios(ofItem item: Item) -> [Ratio] {
        return Array(realm.objects(Ratio.self).filter("item == %@", item).sorted(byKeyPath: "debtor.name"))
    }
    
    // MARK: Currency
    
    var currencies: Results<Currency> {
        return realm.objects(Currency.self).sorted(byKeyPath: "code")
    }
    
    // MARK: Shared
    
    @discardableResult
    func insert(object: Object) -> Error? {
        do {
            try realm.write {
                realm.add(object)
            }
            return nil
        }
        catch let error {
            return error
        }
    }
    
    @discardableResult
    func update(object: Object) -> Error? {
        do {
            try realm.write {
                realm.add(object, update: true)
            }
            return nil
        }
        catch let error {
            return error
        }
    }

    @discardableResult
    func remove<T: Object>(object: T) -> Error? where T: CascadeDelete {
        do {
            object.beforeDelete?()
            try realm.write {
                let objects = object.objectsToDelete()
                objects.forEach({ realm.delete($0) })
            }
            object.afterDelete?()
            return nil
        }
        catch let error {
            return error
        }
    }
}
