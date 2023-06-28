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
    case detail(chosenImageData: ImageSearchResultData.Hit)
    case photo(imageURLString: String)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    private let searchBarView = SearchBarView(viewModel: SearchBarViewViewModel())
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        navigationController.navigationBar.isTranslucent = false
        navigationController.setNavigationBarHidden(true, animated: false)
        
        return navigationController
    }()
    
    init() {
        super.init(rootViewController: navigationController, initialRoute: .search)
        navigationController.navigationBar.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .search:
            let viewModel = SearchViewViewModel(router: unownedRouter)
            let viewController = SearchViewController(viewModel: viewModel)
            return .push(viewController)
            
        case .results(let searchText):
            let viewModel = ResultViewViewModel(networkManager: NetworkManager(),
                                                router: unownedRouter)
            viewModel.currentSearchText = searchText
            let viewController = ResultViewController(searchBarView: searchBarView,
                                                      viewModel: viewModel)
            return .push(viewController)
            
        case .detail(let chosenImageData):
            let viewModel = DetailViewViewModel(router: unownedRouter,
                                                networkManager: NetworkManager(),
                                                imageDownloadManager: ImageDownloadManager(),
                                                imageSaveManager: ImageSaveManager(),
                                                chosenHit: chosenImageData)
            let viewController = DetailViewController(searchBarView: searchBarView,
                                                      viewModel: viewModel)
            return .push(viewController)
        case .photo(imageURLString: let urlString):
            let viewModel = ImageViewViewModel(imageDonwloadManager: ImageDownloadManager(),
                                               imageURL: urlString)
            let viewController = ImageViewController(viewModel: viewModel)
            viewController.modalTransitionStyle = .coverVertical
            viewController.modalPresentationStyle = .fullScreen
            return .present(viewController)
        }
    }
}
