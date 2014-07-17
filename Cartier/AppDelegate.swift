//
//  AppDelegate.swift
//  Cartier
//
//  Created by Gianni Settino on 2014-07-17.
//  Copyright (c) 2014 Milton and Parc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let mainViewController = MainViewController()
        let rootNavController = UINavigationController(rootViewController: mainViewController)
        self.window!.rootViewController = rootNavController
        
        self.window!.makeKeyAndVisible()
        return true
    }
    
}

