//
//  SearchBarViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 27/06/2023.
//

import Foundation

final class SearchBarViewViewModel: SearchBarViewViewModelType {
    @Published var selectedFilter: ImageSearchAPI.QueryParameters.Order = .popular
    var selectedFilterPublisher: Published<ImageSearchAPI.QueryParameters.Order>.Publisher { $selectedFilter }
}
