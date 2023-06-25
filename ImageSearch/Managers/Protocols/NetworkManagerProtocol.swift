//
//  NetworkManagerProtocol.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Combine

protocol NetworkManagerProtocol {
    func fetchData(withSearchQuery searchQuery: String, resultOrder: ImageSearchAPI.QueryParameters.Order) -> Future<ImageSearchResultData, Error>
}
