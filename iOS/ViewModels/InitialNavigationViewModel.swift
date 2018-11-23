//
//  InitialNavigationViewModel.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation
import RxSwift

struct InitialNavigationViewModelProtocolOutput {
    let isConnected: Observable<Bool>
}

protocol InitialNavigationViewModelProtocol: ViewModel {
    func transform() -> InitialNavigationViewModelProtocolOutput
}

class InitialNavigationViewModel: InitialNavigationViewModelProtocol {
    
    let realmManager: RealmManager
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }
    
    func transform() -> InitialNavigationViewModelProtocolOutput {
        return InitialNavigationViewModelProtocolOutput(
            isConnected: realmManager.realm.asObservable().map({ realm in
                return realm != nil
            })
        )
    }
}
