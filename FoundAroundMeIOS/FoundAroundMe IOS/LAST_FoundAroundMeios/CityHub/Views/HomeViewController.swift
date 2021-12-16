//
//  RegistrationViewController.swift
//  CityHub
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseFirestore

protocol PopupDelegate: class {
	func loadDataHub()
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, PopupDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lblLocalisation: UILabel!
    
    @IBOutlet weak var txtSendMessage: UITextField!
    
    @IBOutlet weak var txtConversation: UITextView!
    
    @IBOutlet weak var lblchannel: UILabel!
    
    
    //  Create value for maps
    let locationManager = CLLocationManager()
    
    //  Access to localisation
    let apiLocation = APILocation()
    
    //  Access to database
    let apiBdd = APIbdd()
    
    //  Access user data
    let userAccess = UserContext.shared.user
    
    //  Acces localisation data
    let localisationAccess = LocalisationContext.shared.localisation
    
    var messageArray = [MessageHub]()
    
    var db:Firestore!
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //annotation
        mapView.register(PoiAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotations([Location.IUT, Location.GareGrenoble, Location.CinemaLeClub, Location.AgenceTAG, Location.CinemaLeMelias, Location.Cinema6Rex, Location.CinemaPatheGrenoble, Location.mcdoJJ,  Location.mcdoGare, Location.burgerKing,])
        
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        db = Firestore.firestore()
        checkForUpdatesMessageHub()
        self.lblchannel.text = self.userAccess?.getChannel()
        
    }
    
    @IBAction func ChangeMapTypeButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : mapView.mapType = MKMapType.standard
        case 1 : mapView.mapType = .satellite
        default: break
        }
    }
    
    //Check messages from firestore and display messages
    func checkForUpdatesMessageHub(){
        let ref = Firestore.firestore()
        
        
        ref.collection("messagesHub").whereField("dateCreation", isGreaterThan: Date()).addSnapshotListener{
            querySnapshot, error in
            
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                diff in
                
                if(self.localisationAccess?.getCity() != diff.document.data()["city"] as? String){return}
                
                if(self.userAccess?.getChannel() == diff.document.data()["channel"] as? String || self.userAccess?.getChannel() == "Général"){
                    if diff.type == .added {
                        self.messageArray.append(MessageHub(email: diff.document.data()["email"] as! String, pseudo: diff.document.data()["pseudo"] as! String ,content: diff.document.data()["message"] as! String, timeStamp: Date() ))
                        
                        self.updateView()
                        
                        if(diff.document.data()["email"] as! String == self.userAccess?.getEmail() ?? "") {
                            self.txtConversation.text = self.txtConversation.text + "Vous : \(diff.document.data()["message"] as! String) \n"
                            
                        }
                        else {
                            self.txtConversation.text = self.txtConversation.text + "\(diff.document.data()["pseudo"] as! String) : \(diff.document.data()["message"] as! String) \n"
                            
                        }
                    }
                
                    
                }
                else{
                    return
                }
            }
            
        }
    }
        
    
    //  Reload when windows appear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if isBeingDismissed {
            txtConversation.text = ""
        }
        
    }
    
    
    
    //Load data 
    func loadDataHub(){
        if(userAccess?.getChangedChannel() == true){
            self.txtConversation.text = ""
            
            if(userAccess?.getChannel() != "Général"){
                let ref = Firestore.firestore()
                
                ref.collection("messagesHub").order(by: "dateCreation").getDocuments(){
                    querySnapshot, error in
                    if let error = error{
                        print("Salut y a une erreur ici\(error.localizedDescription)")
                    }
                    else{
                        
                        
                        for document in querySnapshot!.documents {
                        
                            if(document.data()["channel"] as? String == self.userAccess?.getChannel() && document.data()["city"] as? String == self.localisationAccess?.getCity()){
                                self.messageArray.append(MessageHub(email: document.data()["email"] as! String, pseudo: document.data()["pseudo"] as! String, content: document.data()["message"] as! String, timeStamp: Date() ))
                                
                                self.updateView()

                                if( document.data()["email"] as! String == self.userAccess?.getEmail() ?? "") {
                                    self.txtConversation.text = self.txtConversation.text + "Vous : \(document.data()["message"] as! String) \n"
                                }
                                else {
                                    self.txtConversation.text = self.txtConversation.text + "\(document.data()["pseudo"] as! String) : \(document.data()["message"] as! String) \n"
                                
                                }
                            }
                            
                            
                        }
                                                
                        
                        //print("Bonjour ceci veut dire que je suis bien dedans")
                        //print("valeur de la variable messageArray \(self.messageArray)")
                        
                    }
                    
                }
            }
            
            userAccess?.setChangedChannel(changedChannel: false)
            self.lblchannel.text = self.userAccess?.getChannel()
        }
        else{return}
        
    }
    
    
    
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        //  Acces to location data
        let localisationAcces = LocalisationContext.shared.localisation
        
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        
        
        //  Updating city info
        apiLocation.getLocalisation(latitude: center.latitude, longitude: center.longitude){ (streetMap) in
            
            DispatchQueue.main.async {
                
                //self.apiBdd.verifMessage()
                
                
                if(streetMap?.address?.village != nil){
                    localisationAcces?.setCity(city: streetMap?.address?.village ?? "")
                    
                }
                if(streetMap?.address?.town != nil){
                    localisationAcces?.setCity(city: streetMap?.address?.town ?? "")
                    
                }
                if(streetMap?.address?.city != nil){
                    localisationAcces?.setCity(city: streetMap?.address?.city ?? "")
                    
                }
                self.lblLocalisation.text = self.localisationAccess?.getCity()
            }
        }
        
        
        
        
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
            
        }
        
        
        
    }
    
    
    func updateView(){
        let range = NSRange(location: txtConversation.text.count - 1, length: 0)
        txtConversation.scrollRangeToVisible(range)
    }
    
    @IBAction func buttonSend() {
    
        if(txtSendMessage.text != ""){
            apiBdd.addMessage(message: ["email": userAccess?.getEmail() ?? "","pseudo": userAccess?.getPseudo() ?? "", "message": txtSendMessage.text ?? "","city": localisationAccess?.getCity() ?? "","dateCreation": Date(), "channel":self.userAccess?.getChannel() ?? "Général"], collection: "messagesHub")
            txtSendMessage.text = ""
            updateView()
        }
      
    }
    
 
	@IBAction func showPopup() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let popupViewController = storyboard.instantiateViewController(withIdentifier: "popupController") as! PopupController
		popupViewController.popupDelegate = self
		self.present(popupViewController, animated: true) {
		}
	}
    
    
    @IBAction func logout(){
        userAccess?.setEmail(email:"")
        userAccess?.setFirstName(firstName:"")
        userAccess?.setLastName(lastName:"")
        userAccess?.setPseudo(pseudo:"")
        userAccess?.setPassword(password:"")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeViewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        self.navigationController?.pushViewController(HomeViewController, animated: true)

    }
    

    
    
   
    
}



