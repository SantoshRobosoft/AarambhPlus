//
//  VideoListController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/10/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class VideoListController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Videos"
    }

    class func controller() -> VideoListController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(VideoListController.self)") as! VideoListController
    }

}
