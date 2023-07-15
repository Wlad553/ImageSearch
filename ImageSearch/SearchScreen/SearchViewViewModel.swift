//
//  SearchViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import Foundation
import XCoordinator

final class SearchViewViewModel: SearchViewViewModelType {
    private let router: WeakRouter<AppRoute>
        
    init(router: WeakRouter<AppRoute>) {
        self.router = router
    }
    
    func didPressSearchButton(searchText: String) {
        router.trigger(.results(searchText: searchText))
    }
}
