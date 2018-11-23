//
//  RealmManager.swift
//  Machac
//
//  Created by Jan on 17/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class RealmManager {
    private let disposeBag = DisposeBag()
    
    let constants: Constants
    let settings: AppSettings
    
    let realm = Variable<Realm?>.init(nil)
//    private(set) var realm: Realm! {
//        didSet {
//            if realm != nil && oldValue == nil {
//                initReferenceCurrency()
//                NotificationCenter.default.post(name: Notification.Name("RealmInitialized"), object: nil)
//            }
//        }
//    }
    
    private var token: SyncSession.ProgressNotificationToken?
    
    init(constants: Constants, settings: AppSettings) {
        self.constants = constants
        self.settings = settings
        
        realm.asObservable().subscribe(onNext: { [weak self] realm in
            if realm == nil {
                self?.loginSyncUser(register: true)
            } else {
                self?.initReferenceCurrency()
            }
        })
            .disposed(by: disposeBag)
    }
    
    // MARK: People
    
    var people: Results<Person> {
        return realm.value!.objects(Person.self).sorted(byKeyPath: "name")
    }
    
    func people(without person: Person) -> Results<Person> {
        return realm.value!.objects(Person.self).filter("id != '\(person.id)'").sorted(byKeyPath: "name")
    }
    
    func people(without people: [Person]) -> Results<Person> {
        return realm.value!.objects(Person.self).filter("NOT (id IN %@)", people.map({ $0.id })).sorted(byKeyPath: "name")
    }

    func person(withId id: String) -> Results<Person> {
        return realm.value!.objects(Person.self).filter("id == '\(id)'")
    }

    // MARK: Items
    
    func items(inCurrency currency: Currency) -> Results<Item> {
        return realm.value!.objects(Item.self).filter("currency == %@", currency)
    }
    
    // MARK: Ratios
    
    func ratios(ownedBy owner: Person) -> Results<Ratio> {
        return realm.value!.objects(Ratio.self).filter("item.owner == %@", owner)
    }
    
    func ratios(consumedBy consumer: Person) -> Results<Ratio> {
        return realm.value!.objects(Ratio.self).filter("debtor == %@", consumer)
    }

    func ratios(ownedBy owner: Person, consumedBy consumer: Person) -> Results<Ratio> {
        return realm.value!.objects(Ratio.self).filter("item.owner == %@ AND debtor == %@", owner, consumer)
    }
    
    func ratios(ofItem item: Item) -> [Ratio] {
        return Array(realm.value!.objects(Ratio.self).filter("item == %@", item).sorted(byKeyPath: "debtor.name"))
    }
    
    // MARK: Currency
    
    var currencies: Results<Currency> {
        return realm.value!.objects(Currency.self).sorted(byKeyPath: "code")
    }
    
    // MARK: Shared
    
    @discardableResult
    func insert(object: Object) -> Error? {
        do {
            try realm.value!.write {
                realm.value!.add(object)
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
            try realm.value!.write {
                realm.value!.add(object, update: true)
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
            object.beforeDelete(manager: self)
            try realm.value!.write {
                let objects = object.objectsToDelete()
                objects.forEach({ realm.value!.delete($0) })
            }
            object.afterDelete()
            return nil
        }
        catch let error {
            return error
        }
    }
}

private extension RealmManager {
    func initReferenceCurrency() {
        if let index = currencies.index(where: { $0.isReference }) {
            settings.updateReferenceCurrency(with: currencies[index])
        }
        else {
            let czk = Currency(code: Currency.defaultCode, relationToCzk: 1, isReference: true)
            insert(object: czk)
            settings.updateReferenceCurrency(with: czk)
        }
    }
    
    func loginSyncUser(register: Bool) {
        let serverURL = constants.realm.serverUrl
        let credentials = SyncCredentials.usernamePassword(username: constants.realm.username, password: constants.realm.password, register: register)
        if let user = SyncUser.current {
            createRealm(forUser: user)
        }
        else {
            SyncUser.logIn(with: credentials,
                           server: serverURL) { user, error in
                            if let user = user {
                                self.createRealm(forUser: user)
                            } else {
                                self.loginSyncUser(register: false)
                            }
            }
        }
    }
    
    func createRealm(forUser user: SyncUser) {
        DispatchQueue.main.async {
            let syncServerURL = self.constants.realm.realmUrl
            let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
            self.realm.value = try? Realm(configuration: config)
        }
    }
}
