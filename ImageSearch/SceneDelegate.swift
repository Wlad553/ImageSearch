//
//  SceneDelegate.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import UIKit
import XCoordinator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var router = AppCoordinator().strongRouter
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        if let window = window {
            router.setRoot(for: window)
        }
    }
}

