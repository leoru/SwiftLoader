//
//  AppDelegate.swift
//  SwiftLoaderExample
//
//  Created by Kirill Kunst on 11.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        var vc = ViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        self.window?.becomeKeyWindow()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }


}

