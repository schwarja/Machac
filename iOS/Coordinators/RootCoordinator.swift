//
//  RootCoordinator.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import UIKit

class RootCoordinator {
    let dependency: Dependency
    let window: UIWindow
    
    init(dependency: Dependency, window: UIWindow) {
        self.dependency = dependency
        self.window = window
        
        let controller = R.storyboard.main().instantiateInitialViewController() as? InitialNavigationController
        let coordinator = InitialCoordinator(dependency: dependency)
        let realmManager = dependency.manager(of: RealmManager.self)
        let viewModel = InitialNavigationViewModel(realmManager: realmManager)
        controller?.set(coordinator: coordinator, viewModel: viewModel)
        window.rootViewController = controller
    }
}
