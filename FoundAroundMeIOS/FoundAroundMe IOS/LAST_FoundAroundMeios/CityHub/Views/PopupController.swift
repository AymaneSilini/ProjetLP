//
//  PopupController.swift
//  CityHub


import UIKit

class PopupController: UIViewController{

    
    @IBOutlet weak var popupView: UIView!
	weak var popupDelegate: PopupDelegate?
	
    //  Access user data
    let userAcces = UserContext.shared.user
    
    
    
    @IBAction func dismissPopup(_ sender: UIButton) {
		
        dismiss(animated: true, completion: nil)
    }
    
    // Access to channel general
    @IBAction func accessGeneral(_ sender: UIButton) {
        userAcces?.setChannel(channel: "Général")
        userAcces?.setChangedChannel(changedChannel: true)
        dismiss(animated: true, completion: {
			self.popupDelegate?.loadDataHub()
		})
    }
    
    //Access to channel politics
    @IBAction func accessTransport(_ sender: UIButton) {
        userAcces?.setChannel(channel: "Transport")
        userAcces?.setChangedChannel(changedChannel: true)
        dismiss(animated: true, completion: {
            self.popupDelegate?.loadDataHub()
        })
        
    }
    
    //Access to channel Board Game
    @IBAction func accessRestauration(_ sender: UIButton) {
        userAcces?.setChannel(channel: "Restauration")
        userAcces?.setChangedChannel(changedChannel: true)
        dismiss(animated: true, completion: {
            self.popupDelegate?.loadDataHub()
        })

    }
    
    //Access to channel Video Game
    @IBAction func accessJeuxVideo(_ sender: UIButton) {
        userAcces?.setChannel(channel: "Jeux video")
        userAcces?.setChangedChannel(changedChannel: true)
        dismiss(animated: true, completion: {
            self.popupDelegate?.loadDataHub()
            
        })
    }
    
    //Access to channel Meet
    @IBAction func accessRencontre(_ sender: UIButton) {
        userAcces?.setChannel(channel: "Rencontre")
        userAcces?.setChangedChannel(changedChannel: true)
        dismiss(animated: true, completion: {
            self.popupDelegate?.loadDataHub()
            
        })
    }
    
    //Access to channel Discover
    @IBAction func accessCulture(_ sender: UIButton) {
        userAcces?.setChannel(channel: "Culture")
        userAcces?.setChangedChannel(changedChannel: true)
        dismiss(animated: true, completion: {
            self.popupDelegate?.loadDataHub()
        })
        
    }
    
    
    
    
    
    
    
    

}
