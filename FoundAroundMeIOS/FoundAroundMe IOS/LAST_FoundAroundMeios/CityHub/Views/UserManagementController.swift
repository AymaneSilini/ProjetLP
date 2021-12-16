//
//  UserSettingController.swift
//  CityHub
//
//  Created by Dorian Artillan on 07/12/2020.
//


import UIKit
import FirebaseFirestore


import UIKit
import FirebaseFirestore


enum DataVU: String {
    case userManagement = "Utilisateur 1"
    case moderation = "Utilisateur 2"
    case option1 = "Utilisateur 3"
    case option2 = "Utilisateur 4"
    case option3 = "Utilisateur 5"
    case option4 = "Utilisateur 6"
}

class UserManagementController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var customTableView: UITableView!
    
    let datas: [DataVU] = [.userManagement, .moderation, .option1, .option2, .option3, .option4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        customTableView.delegate = self
        customTableView.dataSource = self
    }
    
    //MARK: - Events Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Titre de section"
        titleView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return titleView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customTableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        cell.titleLabel.text = datas[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        pushViewController(data)
        
        customTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func pushViewController(_ dataVC: DataVU) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var nextViewController: UIViewController!
        
        switch dataVC {
        case .userManagement:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        case .moderation:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        case .option1:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        case .option2:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        case .option3:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        case .option4:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func btnAccesUser(_ sender: Any) {
        // Redirecting to user page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }

}






