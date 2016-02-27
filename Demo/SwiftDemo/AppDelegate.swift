//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by Stefan Ceriu on 16/02/2016.
//  Copyright © 2016 Stefan Ceriu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = RootViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

