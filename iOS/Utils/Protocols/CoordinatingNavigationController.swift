//
//  File.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation

protocol CoordinatingNavigationController: class {
    associatedtype C: NavigationCoordinator
    associatedtype M: ViewModel
    
    init(coordinator: C, viewModel: M)
}

protocol CoordinatingNavigationControllerWithStoryboard: class {
    associatedtype C
    associatedtype M
    
    var coordinator: C! { get set }
    var viewModel: M! { get set }

    func set(coordinator: C, viewModel: M)
}

extension CoordinatingNavigationControllerWithStoryboard {
    func set(coordinator: C, viewModel: M) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
}
