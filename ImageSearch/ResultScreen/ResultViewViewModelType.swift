//
//  ResultViewViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import Foundation
import Combine

protocol ResultViewViewModelType: AnyObject {
    var searchResultData: ImageSearchResultData? { get }
    var networkManager: NetworkManagerProtocol { get }
    var currentSearchText: String { get set }
    func fetchData() -> Future<Void, Error>
    func cleanSearchResultData()
    func numberOfImageResultItems() -> Int
    func numberOfRelatedCategoryItems() -> Int
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelType
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType?
    func imageResultsHeaderViewViewModel() -> ImageResultsHeaderViewViewModelType?
}
