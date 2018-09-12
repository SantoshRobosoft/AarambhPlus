//
//  ViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func addGradient() {
        let colorTop = UIColor.colorRGB(255, g: 200, b: 55).cgColor
        let colorBottom = UIColor.colorRGB(255, g: 128, b: 8).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let submitAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    func parseError<T>(_ result: DataResult<T>) -> APIResponse<T>? {
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            showAlert(title: nil, message: error.localizedDescription())
        }
        return nil
    }
}

