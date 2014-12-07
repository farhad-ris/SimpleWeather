//
//  MainViewController.swift
//  SimpleWeather
//
//  Created by Kevin Xu on 12/7/14.
//  Copyright (c) 2014 Kevin Xu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

