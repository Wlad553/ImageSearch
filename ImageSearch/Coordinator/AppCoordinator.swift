//
//  ImageSearchRoute.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 20/06/2023.
//

import XCoordinator

enum AppRoute: Route {
    case search
    case results(searchText: String)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    init() {
        super.init(initialRoute: .search)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .search:
            let viewModel = SearchViewViewModel(networkManager: NetworkManager(),
                                                router: unownedRouter)
            let viewController = SearchViewController(viewModel: viewModel)
            return .push(viewController)
        case .results(let searchText):
            let viewModel = ResultViewViewModel(networkManager: NetworkManager(),
                                                router: unownedRouter)
            let viewController = ResultViewController(viewModel: viewModel)
            viewController.resultView.searchTextField.text = searchText
            return .push(viewController)
        }
    }
}
