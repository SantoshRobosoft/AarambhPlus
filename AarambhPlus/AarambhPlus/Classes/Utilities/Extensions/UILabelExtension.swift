//
//  UILabelExtension.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

extension UILabel {
    
    

}

extension UIView {
    
    func applyCircle() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func roundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func applyBorder(borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func addBorderShadow(color: UIColor?, opacity: Float?, radius: CGFloat?, offset: CGSize?) {
        self.layer.shadowColor = color?.cgColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        self.layer.shadowOpacity = opacity ?? 1.0
        self.layer.shadowOffset = offset ?? CGSize.zero
        self.layer.shadowRadius = radius ?? 4.0
        self.layer.masksToBounds = false
    }
    
    func addShadow() {
        let viewShadow = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        viewShadow.center = self.center
        viewShadow.backgroundColor = UIColor.yellow
        viewShadow.layer.shadowColor = UIColor.red.cgColor
        viewShadow.layer.shadowOpacity = 1
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 5
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
}


extension Notification.Name {
    public static let audioPlayerStateChanged = Notification.Name(rawValue: "audioPlayerStateChanged")
}
