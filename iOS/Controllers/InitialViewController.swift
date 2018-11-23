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
    var viewModel: InitialViewControllerModelProtocol!
    var presenter: InitialViewControllerPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension InitialViewController: InjectableViewControllerWithStoryboard {}

private extension InitialViewController {
    func setupUI() {
        navigationItem.title = presenter.title
        
        tableView.delegate = self
    }
}
