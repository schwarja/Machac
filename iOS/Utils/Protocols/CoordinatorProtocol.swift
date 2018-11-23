//
//  CoordinatorProtocol.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation

protocol Coordinator {
    var dependency: Dependency { get }
}

protocol NavigationCoordinator: Coordinator {}
protocol TabBarCoordinator: Coordinator {}
