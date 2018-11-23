//
//  InitialViewControllerPresenter.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation

protocol InitialViewControllerPresenterProtocol: Presenter {
    var title: String { get }
}

struct InitialViewControllerPresenter: InitialViewControllerPresenterProtocol {
    let title = "Machac"
}
