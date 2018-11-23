//
//  CascadeDelete.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift

protocol CascadeDelete {
    func beforeDelete(manager: RealmManager)
    func objectsToDelete() -> [Object]
    func afterDelete()
}

extension CascadeDelete {
    func beforeDelete(manager: RealmManager) {}
    func afterDelete() {}
}
