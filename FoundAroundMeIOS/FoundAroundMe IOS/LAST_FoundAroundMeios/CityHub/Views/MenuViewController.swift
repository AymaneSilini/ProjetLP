//
//  MenuViewController.swift
//  CityHub
//
//  Created by olivier on 07/12/2020.
//

import UIKit

enum MenuType: Int {
    case home
    case profile
    case other
}

class MenuViewController: UITableViewController {

    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true){ [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }

}
