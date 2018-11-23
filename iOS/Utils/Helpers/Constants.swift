//
//  Constants.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation

struct Constants {
    let realm = Realm()
}

extension Constants {
    struct Realm {
        let serverUrl = URL(string: "http://52.233.193.105:9080")!
        let username = "schwarja"
        let password = "SuperTajneHeslo/12"
        let realmUrl = URL(string: "realm://52.233.193.105:9080/~/userRealm")!
    }
}
