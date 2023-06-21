//
//  ResultViewViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import Foundation

protocol ResultViewViewModelType: AnyObject {
    var searchResultData: ImageSearchResultData { get }
    var networkManager: NetworkManagerProtocol { get }
    func numberOfImageResultItems() -> Int
    func numberOfRelatedCategoryItems() -> Int
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelType
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType
    func imageResultsHeaderViewViewModel() -> ImageResultsHeaderViewViewModelType
}
