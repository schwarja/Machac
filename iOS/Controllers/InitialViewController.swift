//
//  InitialViewController.swift
//  Machac
//
//  Created by Jan on 18/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit
import SVProgressHUD

class InitialViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if RealmManager.shared.realm == nil {
            NotificationCenter.default.addObserver(forName: Notification.Name("RealmInitialized"), object: nil, queue: nil, using: { [weak self] _ in
                SVProgressHUD.dismiss()
                self?.setupAppSetings()
            })
            SVProgressHUD.show()
        }
        else {
            setupAppSetings()
        }
        
        setupUI()
    }

    @IBAction func additem(_ sender: Any) {
        let controller = ItemOwnerViewController()
        let navigation = UINavigationController(rootViewController: controller)
        present(navigation, animated: true, completion: nil)
    }
    
    // MARK: - Table View
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let controller = PeopleViewController()
            navigationController?.pushViewController(controller, animated: true)
            
        case 2:
            let controller = CurrenciesViewController()
            navigationController?.pushViewController(controller, animated: true)
            
        default:
            break
        }
    }
}

private extension InitialViewController {
    
    func setupUI() {
        navigationItem.title = "Machac"
        
        tableView.delegate = self
    }
    
    func setupAppSetings() {
        AppSettings.shared.initialize()
    }
}
