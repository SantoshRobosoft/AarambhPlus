//
//  ImageViewExtension.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setKfImage(_ urlstring: String?, placeholder: UIImage? = nil, cacheName: String? = nil, completionHandler: ((UIImage?, Error?) -> Void)? = nil) {
        self.kf.cancelDownloadTask()
        let url = urlstring?.stringByDecodingAndEncoding()
        if let urlStr = url, let url = URL(string: urlStr) {
            let resourece = ImageResource(downloadURL: url, cacheKey: cacheName ?? url.absoluteString)
            self.kf.setImage(with: resourece, placeholder: placeholder, options: nil, progressBlock: { _, _ in
            }, completionHandler: { imagr, error, _, _ in
                completionHandler?(imagr, error)
            })
        } else if let placeholder = placeholder {
            self.image = placeholder
        }
    }
    
    func removeKfImage(forKey key: String?) {
        if let key = key {
            ImageCache.default.removeImage(forKey: key)
        }
    }
    
    func addBlurEffect() {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
    }
    
    func addGradientView() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = frame
        self.layer.insertSublayer(gradient, at: 0)
    }
}
