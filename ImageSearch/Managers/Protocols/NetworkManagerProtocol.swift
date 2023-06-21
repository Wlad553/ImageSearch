//
//  NetworkManagerProtocol.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func requestData(withSearchQuery searchQuery: String, completionHandler: @escaping (Result<ImageSearchResultData, AFError>) -> Void)
}
