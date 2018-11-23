//
//  AppDependency.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation
import Swinject

struct AppDependency {
    private let container = Container()
    
    init() {
        container.register(Constants.self) { _ in
            return Constants()
        }
        container.register(AppSettings.self) { _ in
            return AppSettings()
        }
        container.register(RealmManager.self) { r in
            let constants = r.resolve(Constants.self)!
            let settings = r.resolve(AppSettings.self)!
            return RealmManager(constants: constants, settings: settings)
        }
        container.register(ExportManager.self) { r in
            let realmManager = r.resolve(RealmManager.self)!
            return ExportManager(realmManager: realmManager)
        }
    }
}

extension AppDependency: Dependency {
    func manager<T>(of type: T.Type) -> T {
        return container.resolve(type)!
    }
}
