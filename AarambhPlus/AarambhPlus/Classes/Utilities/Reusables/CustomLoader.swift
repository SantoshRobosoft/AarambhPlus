//
//  CustomLoader.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class CustomLoader: UIView {
    
    private let indicator = UIActivityIndicatorView()
    private let gradView = UIView()
    private let wh = CGFloat(60)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag = CustomLoaderTag
        
        gradView.frame = CGRect(x: frame.width/2-wh/2, y: frame.height/2-wh/2, width: wh, height: wh)
        self.addSubview(gradView)
        gradView.backgroundColor = UIColor.white
        
        let hh = CGFloat(30)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.frame = CGRect(x: gradView.frame.width/2-hh/2, y: gradView.frame.height/2-hh/2, width: hh, height: hh)
        indicator.startAnimating()
        gradView.addSubview(indicator)
        self.backgroundColor = UIColor.colorRGB(30, g: 30, b: 30, a: 0.05)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideGradient(_ hide: Bool) {
        gradView.backgroundColor = hide ? UIColor.clear : UIColor.white
    }
    
    func isSmallInd(small: Bool) {
        indicator.activityIndicatorViewStyle = small ? .white : .whiteLarge
        indicator.color = UIColor.black
    }
    
    // MARK: - Class methods
    class func addLoaderOn(_ aView: UIView!, gradient: Bool) {
        CustomLoader.addLoaderOn(aView, gradient: gradient, small: false)
    }
    
    class func addLoaderOn(_ aView: UIView!, gradient: Bool, small: Bool) {
        CustomLoader.removeLoaderFrom(aView)
        DispatchQueue.main.async {
            let loader = CustomLoader(frame: aView.bounds)
            loader.isSmallInd(small: small)
            loader.hideGradient(!gradient)
            aView.addSubview(loader)
        }
    }
    
    class func removeLoaderFrom(_ aView: UIView?) {
        DispatchQueue.main.async {
            if let loader = aView?.viewWithTag(CustomLoaderTag) {
                loader.removeFromSuperview()
            }
        }
    }
}
