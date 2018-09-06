//
//  HomeScreenController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class HomeScreenController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func controller() -> HomeScreenController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(HomeScreenController.self)") as! HomeScreenController
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(HomeScreenController.controller(), animated: true)
    }
    

}
