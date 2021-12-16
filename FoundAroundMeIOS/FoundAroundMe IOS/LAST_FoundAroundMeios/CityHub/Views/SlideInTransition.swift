//
//  SlideInTransition.swift
//  CityHub
//


import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    let dimmingView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        let containerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 0.8
        
        let finalHeight = toViewController.view.bounds.height
        
        if isPresenting{
            //Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)
            
            //Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        
        //Animate on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        
        //Animate back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController?.view.transform = .identity
        }
        
        //Animation of the transtion
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity ()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    

}
