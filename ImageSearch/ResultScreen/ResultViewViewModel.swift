//
//  ResultViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 16/06/2023.
//

import UIKit
import XCoordinator

final class ResultViewViewModel: ResultViewViewModelType {
    let networkManager: NetworkManagerProtocol
    let router: UnownedRouter<AppRoute>
    var searchResultData: ImageSearchResultData
    
    init(searchResultData: ImageSearchResultData, networkManager: NetworkManagerProtocol, router: UnownedRouter<AppRoute>) {
        self.searchResultData = searchResultData
        self.networkManager = networkManager
        self.router = router
    }
    
    func searchResultCategories() -> [String] {
        var searchResultCategories: [String] = []
        for hit in searchResultData.hits {
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
        return searchResultData.hits.count
    }
    
    func numberOfRelatedCategoryItems() -> Int {
        return searchResultCategories().count
    }
    
    // MARK: ViewModels
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelType {
        return CategoryCellViewModel(categoryLabelText: searchResultCategories()[indexPath.row])
    }
    
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType {
        return ImageResultsCellViewModel(cellImageURL: searchResultData.hits[indexPath.row].webformatURL, imageDownloadManager: ImageDownloadManager())
    }
    
    func imageResultsHeaderViewViewModel() -> ImageResultsHeaderViewViewModelType {
        return ImageResultsHeaderViewViewModel(resultsNumber: searchResultData.total)
    }
}
