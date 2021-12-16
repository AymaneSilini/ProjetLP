//
//  NavigationController.swift
//  CityHub
//
//  Created by Dorian Artillan on 07/12/2020.
//

import UIKit
import FirebaseFirestore

class NavigationController: UIViewController{
    
    let transition = SlideInTransition()
    var topView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func transitionToNew(_ menuType : MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .other:
            let view = UIView()
            view.backgroundColor = .blue
            view.frame = self.view.bounds
            self.view.addSubview(view)
            self.topView = view
        default:
            break
        }
    }
}

extension NavigationController: UIViewControllerTransitioningDelegate{
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
}
