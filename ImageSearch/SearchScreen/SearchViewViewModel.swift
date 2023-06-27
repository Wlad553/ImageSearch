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
    let router: UnownedRouter<AppRoute>
        
    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }
    
    func didPressSearchButton(searchText: String) {
        router.trigger(.results(searchText: searchText))
    }
}
