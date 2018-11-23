//
//  InjectableViewController.swift
//  Machac
//
//  Created by Jan on 13/11/2018.
//  Copyright © 2018 Schwarja. All rights reserved.
//

import Foundation

protocol InjectableViewController: class {
    associatedtype M: ViewModel
    associatedtype P: Presenter
    
    var presenter: P { get }
    var viewModel: M { get }
    
    init(viewModel: M, presenter: P)
}

protocol InjectableViewControllerWithStoryboard: class {
    associatedtype M//: ViewModel
    associatedtype P//: Presenter
    
    var presenter: P! { get set }
    var viewModel: M! { get set }
    
    func set(viewModel: M, presenter: P)
}

extension InjectableViewControllerWithStoryboard {
    func set(viewModel: M, presenter: P) {
        self.viewModel = viewModel
        self.presenter = presenter
    }
}
