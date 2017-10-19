//
//  UIViewControllerExtension.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func cancel() {
        if navigationController?.viewControllers.count == 1 {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }

}
