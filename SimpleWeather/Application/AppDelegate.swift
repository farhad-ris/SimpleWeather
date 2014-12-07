//
//  AppDelegate.swift
//  SimpleWeather
//
//  Created by Kevin Xu on 12/7/14.
//  Copyright (c) 2014 Kevin Xu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
        self.window?.rootViewController = MainViewController()
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        
        TSMessage.setDefaultViewController(self.window?.rootViewController)
        
        return true
    }
}

