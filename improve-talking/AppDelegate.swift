//
//  AppDelegate.swift
//  improve-talking
//
//  Created by Erik Perez on 10/7/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        let homeViewController = ChatViewController(roomName: "Test", token: "12345")
        self.window = window
        window.rootViewController = homeViewController
        window.makeKeyAndVisible()
        return true
    }
}

