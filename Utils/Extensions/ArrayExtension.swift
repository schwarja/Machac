//
//  ArrayExtension.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation

extension Collection {
    
    public func find(predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.Iterator.Element? {
        if let index = try self.index(where: predicate) {
            return self[index]
        }
        else {
            return nil
        }
    }

}
