//
//  ImageViewNavigationController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 13/07/2023.
//

import UIKit

final class ImageViewNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .fullScreen
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black.withAlphaComponent(0.5)
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
