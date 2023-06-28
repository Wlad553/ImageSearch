//
//  NetworkManagerProtocol.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Combine
import UIKit

protocol NetworkManagerProtocol: AnyObject {
    func fetchData(withSearchQuery searchQuery: String, resultOrder: ImageSearchAPI.QueryParameters.Order) -> Future<ImageSearchResultData, Error>
    func downloadImage(withURL url: String) -> Future<UIImage, Error>
}
