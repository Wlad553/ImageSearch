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
        router.trigger(.results(searchText: searchText))
    }
}
