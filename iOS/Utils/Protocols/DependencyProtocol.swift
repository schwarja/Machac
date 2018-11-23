//
//  DependencyProtocol.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation

protocol Dependency {
    func manager<T>(of type: T.Type) -> T
    func weakManager<T>(of type: T.Type) -> T?
}

extension Dependency {
    func weakManager<T>(of type: T.Type) -> T? {
        return nil
    }
}
