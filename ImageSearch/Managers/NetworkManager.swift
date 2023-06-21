//
//  NetworkManager.swift.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Foundation
import Alamofire

enum ImageSearchAPI: String {
    case apiKey = "37206235-417ae468352b299c4b0eb5862"

    enum QueryParameters {
        enum ImageType: String {
            case all = "&image_type=all"
            case photo = "&image_type=photo"
            case vector = "&image_type=vector"
        }
    }
}

class NetworkManager: NetworkManagerProtocol {
    func requestData(withSearchQuery searchQuery: String, completionHandler: @escaping (Result<ImageSearchResultData, AFError>) -> Void) {
        let urlString = "https://pixabay.com/api/?key=\(ImageSearchAPI.apiKey.rawValue)&q=\(searchQuery)"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseDecodable(of: ImageSearchResultData.self) { dataResponse in
            if case let .success(data) = dataResponse.result {
                completionHandler(.success(data))
            } else if case let .failure(error) = dataResponse.result {
                completionHandler(.failure(error))
            }
        }
    }
}
