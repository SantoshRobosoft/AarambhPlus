//
//  FadeTransition.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

 enum TransitionType: NSInteger {
    case Fade = 0, DropDown = 1
}


class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
            if !(toViewController.presentedViewController == fromViewController) {
                //Presenting Animation
                presentControllerFrom(fromViewController, to: toViewController, withTransition: transitionContext)
            } else {
                //Dismiss Animation
                dismissController(fromViewController, to: toViewController, withTransition: transitionContext)
            }
        }
    }
    
    
    var transitionType: TransitionType = .Fade
    var isFromLoginScreen = false
    
    func presentControllerFrom(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
        presetToOriginalValue(reset: true, of: toController)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {[weak self] () -> Void in
            
            self?.presetToOriginalValue(reset: false, of: toController)
        }) { (finished: Bool) -> Void in
            transitionContext.completeTransition(true)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func dismissController(_ fromController: UIViewController, to toController: UIViewController, withTransition transitionContext: UIViewControllerContextTransitioning) {
        presetToOriginalValue(reset: false, of: fromController)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {[weak self] () -> Void in
            self?.presetToOriginalValue(reset: true, of: fromController)
        }) { (finished: Bool) -> Void in
            transitionContext.completeTransition(true)
        }
    }
    
    
    fileprivate func presetToOriginalValue(reset: Bool, of controller: UIViewController) {
        if  transitionType == .Fade {
            controller.view.alpha = reset ? 0 : 1
        } else {
//            controller.view.frame.height = reset ? 64 : windowWidth
        }
        
    }
}
