//
//  InitialNavigationController.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class InitialNavigationController: UINavigationController {
    let disposeBag = DisposeBag()
    
    var coordinator: InitialCoordinatorProtocol!
    var viewModel: InitialNavigationViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        if let controller = viewControllers.first as? InitialViewController {
            coordinator.setupRootViewController(controller: controller)
        }
    }
}

extension InitialNavigationController: CoordinatingNavigationControllerWithStoryboard {
}

private extension InitialNavigationController {
    func bind() {
        let output = viewModel.transform()
        
        output.isConnected.subscribe(onNext: { isConnected in
            if isConnected {
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.show()
            }
        }).disposed(by: disposeBag)
    }
}
