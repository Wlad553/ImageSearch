//
//  SearchBarViewViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 27/06/2023.
//

import Foundation

protocol SearchBarViewViewModelType: AnyObject {
    var selectedFilter: ImageSearchAPI.QueryParameters.Order { get set }
    var selectedFilterPublisher: Published<ImageSearchAPI.QueryParameters.Order>.Publisher { get }
}
