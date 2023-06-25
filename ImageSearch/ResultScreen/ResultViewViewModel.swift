//
//  ResultViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 16/06/2023.
//

import UIKit
import XCoordinator
import Combine

final class ResultViewViewModel: ResultViewViewModelType {    
    let networkManager: NetworkManagerProtocol
    let router: UnownedRouter<AppRoute>
    var searchResultData: ImageSearchResultData?
    var currentSearchText: String
    var selectedFilter: ImageSearchAPI.QueryParameters.Order = .popular
    
    private var subscriber: AnyCancellable?
    
    init(networkManager: NetworkManagerProtocol, router: UnownedRouter<AppRoute>) {
        self.networkManager = networkManager
        self.router = router
        currentSearchText = ""
    }
    
    func fetchData() -> Future<Void, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            subscriber = networkManager.fetchData(withSearchQuery: currentSearchText, resultOrder: selectedFilter)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        promise(.success(Void()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }, receiveValue: { [weak self] searchResultData in
                    self?.searchResultData = searchResultData
                })
        }
    }
    
    func searchResultCategories() -> [String] {
        var searchResultCategories: [String] = []
        guard let searchResultDataSafe = searchResultData else { return searchResultCategories }
        
        for hit in searchResultDataSafe.hits {
            let hitCategories = hit.tags.components(separatedBy: ", ")
            
            for category in hitCategories {
                let words = category.components(separatedBy: " ")
                let capitalizedCategory = words.map { word in
                    let firstCharacter = word.prefix(1).uppercased()
                    let remainingCharacters = word.dropFirst()
                    return firstCharacter + remainingCharacters
                }.joined(separator: " ")
                guard !searchResultCategories.contains(capitalizedCategory) else { continue }
                searchResultCategories.append(capitalizedCategory)
            }
        }
        return searchResultCategories
    }
    
    // MARK: UICollectionViewDataSource data
    func numberOfImageResultItems() -> Int {
        guard let searchResultDataSafe = searchResultData else { return 0 }
        return searchResultDataSafe.hits.count
    }
    
    func numberOfRelatedCategoryItems() -> Int {
        return searchResultCategories().count
    }
    
    // MARK: ViewModels
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelType {
        return CategoryCellViewModel(categoryLabelText: searchResultCategories()[indexPath.row])
    }
    
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType? {
        guard let searchResultDataSafe = searchResultData else { return nil }
        return ImageResultsCellViewModel(cellImageURL: searchResultDataSafe.hits[indexPath.row].webFormatURL, fullImageURL: searchResultDataSafe.hits[indexPath.row].largeImageURL, imageDownloadManager: ImageDownloadManager())
    }
    
    func imageResultsHeaderViewViewModel() -> ImageResultsHeaderViewViewModelType? {
        guard let searchResultDataSafe = searchResultData else { return nil }
        return ImageResultsHeaderViewViewModel(resultsNumber: searchResultDataSafe.total)
    }
}
