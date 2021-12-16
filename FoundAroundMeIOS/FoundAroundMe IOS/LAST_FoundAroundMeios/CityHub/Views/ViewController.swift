//
//  ViewController.swift
//  CityHub
//


import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    
    /* OUTLET */
    //  Enter email
    @IBOutlet weak var txtEmail: UITextField!
    
    //  Enter password
    @IBOutlet weak var txtPassword: UITextField!
    
    //  Error message
    @IBOutlet weak var lblValidationMessage :
        UILabel!
        
    
    
    /* Open Windows */
    override func viewDidLoad() {
        super.viewDidLoad()
        UserContext.shared.user = User()
        LocalisationContext.shared.localisation = Localisation()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        lblValidationMessage.isHidden = true
        
        
    }

    
    /* BUTTON */
    //  Connexion to User
    @IBAction func buttonLoginUser(_ sender: Any) {
        
        //  Access to user data
        let userAccess = UserContext.shared.user
        
        //  Create alert when user wrong
        let alert = UIAlertController(title: "Mauvaise saisie", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        
        
        
        //  Verification of existing email
        if (txtEmail.text?.count == 0) {
            lblValidationMessage.isHidden = false
            alert.message = "Veuillez entrer votre adresse email"
            present(alert, animated: true, completion: nil)
            lblValidationMessage.text = "Please enter your Email"
            
        }
        else {
            let email: String = txtEmail.text!
            //  Verification of true email
            if isValidEmail(emailID: email) == false {
                lblValidationMessage.isHidden = false
                alert.message = "Veuillez entrer une adresse email valide"
                present(alert, animated: true, completion: nil)
                lblValidationMessage.text = "Please enter valid email address"
            }
            else {
                //  Verification of existing password
                if (txtPassword.text?.count == 0){
                    lblValidationMessage.isHidden = false
                    alert.message = "Veuillez entrer votre mot de passe"
                    present(alert, animated: true, completion: nil)
                    lblValidationMessage.text = "Please enter your password"
                    
                }
                
            
                else {
                    let password: String = txtPassword.text!
                    let securisedPassword = sha256(str: password)
                    let ref = Firestore.firestore()
                    
                    
                    ref.collection("users").whereField("email", isEqualTo: txtEmail.text ?? "").getDocuments() { (querySnapshot, err) in
                        var acces = false
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            if(document.data()["password"] as! String == securisedPassword){
                                acces = true
                                userAccess?.setEmail(email: document.data()["email"] as! String)
                                userAccess?.setFirstName(firstName: document.data()["firstName"] as! String)
                                userAccess?.setLastName(lastName: document.data()["lastName"] as! String)
                                userAccess?.setPseudo(pseudo: document.data()["pseudo"] as! String)
                                userAccess?.setPassword(password: document.data()["password"] as! String)
                                userAccess?.setAdministrator(administrator: document.data()["administrator"] as? Bool ?? false)
                                let timeStamp = document.data()["dateCreation"] as? NSDate ?? Date() as NSDate
                                userAccess?.setDateCreation(dateCreation: timeStamp as Date)
                            }
                            
                            
                        }
                        if(acces == true){
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if (userAccess?.getAdministrator() == false) {
                                let registrationViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
                                self.navigationController?.pushViewController(registrationViewController, animated: true)
                            }
                        }
                        else{
                            self.lblValidationMessage.isHidden = false
                            self.lblValidationMessage.text = "Nous ne pouvons vous connecter"
                        }
                        
                    }
                }
            }
        }
        return
    }
    
    
    //  VUE : Button of account creation
    @IBAction func buttonRegistrationUser() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationViewController = storyboard.instantiateViewController(withIdentifier: "registrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
    


    
}

