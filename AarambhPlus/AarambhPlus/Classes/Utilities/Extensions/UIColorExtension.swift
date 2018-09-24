//
//  UIColorExtension.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

extension UIColor {

    class func colorRGB(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    class func appColor() -> UIColor {
       return #colorLiteral(red: 0.9722746015, green: 0.6105168462, blue: 0.1090024188, alpha: 1)
    }
}
