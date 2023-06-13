//
//  AppDelegate.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #unavailable(iOS 13.0) {
            window = UIWindow()
            let navigationController = UINavigationController(rootViewController: SearchViewController())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        return true
    }
}

