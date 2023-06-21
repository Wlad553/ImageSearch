//
//  SearchViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import Foundation
import XCoordinator
import Combine

final class SearchViewViewModel: SearchViewViewModelType {
    let networkManager: NetworkManagerProtocol
    let router: UnownedRouter<AppRoute>
        
    init(networkManager: NetworkManagerProtocol, router: UnownedRouter<AppRoute>) {
        self.networkManager = networkManager
        self.router = router
    }
    
    func didPressSearchButton(searchText: String) {
        networkManager.requestData(withSearchQuery: searchText) { result in
            if case let .success(data) = result {
                self.router.trigger(.results(data: data))
            } else if case let .failure(error) = result {
                let message: String
                if (error as NSError).code == 13 {
                    message = "The Internet connection appears to be offline"
                } else {
                    message = "Please try again later"
                }
                self.router.viewController.presentOKAlertController(withTitle: "Search error",
                                                                    message: message)
            }
        }
    }
}
