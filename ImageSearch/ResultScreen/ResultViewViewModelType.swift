//
//  ResultViewViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import Foundation
import Combine
import XCoordinator

protocol ResultViewViewModelType: AnyObject {
    var networkManager: NetworkManagerProtocol { get }
    var searchResultData: ImageSearchResultData? { get }
    var currentSearchText: String { get set }
    var selectedFilter: ImageSearchAPI.QueryParameters.Order { get set }
    
    func fetchData() -> Future<Void, Error>
    func numberOfImageResultItems() -> Int
    func numberOfRelatedCategoryItems() -> Int
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelType
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType?
    func imageResultsHeaderViewViewModel() -> ImageResultsHeaderViewViewModelType?
}
