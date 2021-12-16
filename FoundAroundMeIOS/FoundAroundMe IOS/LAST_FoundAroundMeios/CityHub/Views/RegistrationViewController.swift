//
//  RegistrationViewController.swift
//  CityHub
//


import UIKit
import FirebaseFirestore

class RegistrationViewController: UIViewController {
    
    /* OUVERTURE DE LA PAGE */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        lblEmailVerification.isHidden = true
    }
    
    /* OUTLET */
    //  Enter LastName
    @IBOutlet weak var txtLastName: UITextField!
    
    //  Enter firstName
    @IBOutlet weak var txtFirstName: UITextField!
    
    
    //  Enter pseudo
    @IBOutlet weak var txtPseudo: UITextField!

    //  Entrer email
    @IBOutlet weak var txtEmail: UITextField!
    
    //  Entrer password
    @IBOutlet weak var txtPassword: UITextField!
    
    //  Entrer confirmation password
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblEmailVerification: UILabel!
    
    /* BUTTON */
    //  Create user
    @IBAction func buttonCreationUser() {
        
        //  Create alert when user wrong
        let alert = UIAlertController(title: "ok", message: "ok", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)

        //  Register request
        let lastName: String = txtLastName.text!
        let firstName: String = txtFirstName.text!
        let pseudo: String = txtPseudo.text!
        let email: String = txtEmail.text!
        let password: String = txtPassword.text!
        let confirmPassword: String = txtConfirmPassword.text!
    
        
        // Access DataBase
        let apiBdd = APIbdd()
        
        let ref = Firestore.firestore()
        
		
        ref.collection("users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            var acces = false
            for document in querySnapshot!.documents {
                self.lblEmailVerification.isHidden = false
                self.lblEmailVerification.text = "Cette email existe déja dans nos serveurs"
                print("\(document.documentID) => \(document.data())")
                
                
                
                acces = true
            }
            
                
            if (acces == false){
                self.lblEmailVerification.isHidden = false
                //  Verification of existing email
                if (lastName.count == 0) {
                    alert.message = "Veuillez entrer votre nom"
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else {
                    if (firstName.count == 0) {
                        alert.message = "Veuillez entrer votre prénom"
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    else {
                        if (pseudo.count == 0) {
                            alert.message = "Veuillez entrer votre pseudo"
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        else{
                            if (email.count == 0) {
                                alert.message = "Veuillez entrer une adresse email"
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                            else {
                                if (!isValidEmail(emailID: email)){
                                    alert.message = "Veuillez entrer une adresse email valide"
                                    self.present(alert, animated: true, completion: nil)
                                    return
                                }
                                else {
                                    if (password.count < 6){
                                            alert.message = "Veuillez entrer un mot de passe supérieur à 6 caractères"
                                        self.present(alert, animated: true, completion: nil)
                                        return
                                            
                                    }
                                    else {
                                        if (confirmPassword != password){
                                            alert.message = "Les mots de passes ne sont pas identiques"
                                            self.present(alert, animated: true, completion: nil)
                                            return
                                        }
                                        else {
                                            //  securised password
                                            let securisedPassword = sha256(str: password)

                                                
                                            //  User creation
                                            apiBdd.addUser(users: ["lastName" : lastName, "firstName" : firstName, "pseudo" : pseudo, "email" : email, "password" : securisedPassword, "administrator" : false, "dateCreation": Date() ])
                                            
                                                
                                            // Redirecting to home page
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let registrationViewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
                                            self.navigationController?.pushViewController(registrationViewController, animated: true)
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }

                
                
            }
                
        }
        
    
    }
}



