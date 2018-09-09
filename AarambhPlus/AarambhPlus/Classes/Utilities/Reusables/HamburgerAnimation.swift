//
//  HamburgerAnimation.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit


class SidePanelCustomTransitionAnimator: NSObject {
    var duration    = 0.4
    let bounds = UIScreen.main.bounds
}

extension SidePanelCustomTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)-> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        
        if !(toViewController.presentedViewController == fromViewController) {
            //Presenting Animation
            toViewController.view.frame = finalFrameForVC.offsetBy(dx: -bounds.width, dy: 0)
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: duration, animations: {
                toViewController.view.frame = finalFrameForVC
                fromViewController.view.alpha = 0.5
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
            
        } else {
            //Dismiss Animation
            toViewController.view.frame = finalFrameForVC
            toViewController.view.alpha = 0.5
            containerView.addSubview(toViewController.view)
            containerView.sendSubview(toBack: toViewController.view)
            let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: true)
            snapshotView?.frame = fromViewController.view.frame
            containerView.addSubview(snapshotView!)
            fromViewController.view.removeFromSuperview()
            
            UIView.animate(withDuration: duration, animations: {
                snapshotView?.frame = fromViewController.view.frame.offsetBy(dx: -self.bounds.width, dy: 0)
                toViewController.view.alpha = 1.0
            }, completion: { (finished) in
                snapshotView?.removeFromSuperview()
                transitionContext.completeTransition(true)
                UIApplication.shared.keyWindow!.addSubview(toViewController.view)  //This line of code is very much important otherwise screen will be blank (every thing will be removed from view hierarchy i.e UIWindow is completely empty)
            })
            
        }
    }
}
//
