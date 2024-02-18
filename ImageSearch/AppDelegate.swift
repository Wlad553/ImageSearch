//
//  AppDelegate.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import UIKit
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
#if DEBUG
        NFX.sharedInstance().start()
#endif
        return true
    }
}

