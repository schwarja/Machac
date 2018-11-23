//
//  IntialCoordinator.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation

protocol InitialCoordinatorProtocol: NavigationCoordinator {
    func setupRootViewController<Controller: InjectableViewControllerWithStoryboard>(controller: Controller)
}

class InitialCoordinator: InitialCoordinatorProtocol {
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func setupRootViewController<Controller: InjectableViewControllerWithStoryboard>(controller: Controller) {
        let presenter = InitialViewControllerPresenter()
        let viewModel = InitialViewControllerModel()
        controller.set(viewModel: viewModel as! Controller.M, presenter: presenter as! Controller.P)
    }
}
