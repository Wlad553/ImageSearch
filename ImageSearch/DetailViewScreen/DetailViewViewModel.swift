//
//  DetailViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 26/06/2023.
//

import Foundation
import XCoordinator
import Combine

final class DetailViewViewModel: DetailViewViewModelType {
    private let router: WeakRouter<AppRoute>
    let networkManager: NetworkManagerProtocol
    let imageDownloadManager: ImageDownloadManagerProtocol
    let imageSaveManager: ImageSaveManagerProtocol
    @Published var chosenHit: ImageSearchResultData.Hit
    var chosenHitPublisher: Published<ImageSearchResultData.Hit>.Publisher { $chosenHit }
    var searchResultData: ImageSearchResultData?
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(router: WeakRouter<AppRoute>, networkManager: NetworkManagerProtocol, imageDownloadManager: ImageDownloadManagerProtocol, imageSaveManager: ImageSaveManagerProtocol, chosenHit: ImageSearchResultData.Hit) {
        self.router = router
        self.networkManager = networkManager
        self.imageDownloadManager = imageDownloadManager
        self.imageSaveManager = imageSaveManager
        self.chosenHit = chosenHit
    }
    
    func fetchData(withFilter order: ImageSearchAPI.QueryParameters.Order) -> Future<Void, Error> {
        let searchQueryOptions = chosenHit.tags.components(separatedBy: ImageSearchResultData.Separator.tagsSeparator.rawValue)
        let searchQuery = searchQueryOptions[Int.random(in: 0..<searchQueryOptions.count)]
        return Future { [weak self] promise in
            guard let self = self else { return }
            networkManager.fetchData(withSearchQuery: searchQuery, resultOrder: order)
                .sink { completion in
                    switch completion {
                    case .finished:
                        promise(.success(Void()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] data in
                    self?.searchResultData = data
                    self?.searchResultData?.hits.removeAll { hit in
                        self?.chosenHit.id == hit.id
                    }
                }
                .store(in: &subscribers)
        }
    }
    
    func didTapItem(atIndexPath indexPath: IndexPath) {
        guard let searchResultDataSafe = searchResultData else { return }
        chosenHit = searchResultDataSafe.hits[indexPath.row]
    }
    
    func didTapShowImageButton() {
        router.trigger(.photo(imageURLString: chosenHit.largeImageURL))
    }
    
    // MARK: UICollectionViewDataSource data
    func numberOfImageResultItems() -> Int {
        guard let searchResultDataSafe = searchResultData else { return 0 }
        return searchResultDataSafe.hits.count
    }
    
    // MARK: ViewModels
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType? {
        guard let searchResultDataSafe = searchResultData else { return nil }
        return ImageResultsCellViewModel(cellImageURL: searchResultDataSafe.hits[indexPath.row].webFormatURL,
                                         fullImageURL: searchResultDataSafe.hits[indexPath.row].largeImageURL,
                                         imageDownloadManager: ImageDownloadManager())
    }
}
