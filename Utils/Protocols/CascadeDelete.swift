//
//  CascadeDelete.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation
import RealmSwift

@objc protocol CascadeDelete {
    @objc optional func beforeDelete()
    func objectsToDelete() -> [Object]
    @objc optional func afterDelete()
}
