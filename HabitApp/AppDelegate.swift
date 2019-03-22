//
//  AppDelegate.swift
//  HabitApp
//
//  Created by Tolgahan Arıkan on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let listViewController = DetailsTableViewController.makeStoryboardInstance()

        let window = UIWindow()
        window.rootViewController = listViewController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
