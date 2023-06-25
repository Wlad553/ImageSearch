//
//  NetworkManager.swift.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Foundation
import Alamofire
import Combine
import NaturalLanguage

enum ImageSearchAPI: String {
    case apiKey = "37206235-417ae468352b299c4b0eb5862"

    enum QueryParameters {
        enum Order: String {
            case popular
            case latest
        }
    }
}

enum NetworkError: Error {
    case invalidURL
}

class NetworkManager: NetworkManagerProtocol {
    func fetchData(withSearchQuery searchQuery: String, resultOrder: ImageSearchAPI.QueryParameters.Order) -> Future<ImageSearchResultData, Error> {
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(searchQuery)
        let dominantLanguage = languageRecognizer.dominantLanguage?.rawValue ?? "en"
        let encodedText = searchQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let urlString = "https://pixabay.com/api/?key=\(ImageSearchAPI.apiKey.rawValue)&q=\(encodedText)&lang=\(dominantLanguage)&order=\(resultOrder.rawValue)&per_page=200"
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(NetworkError.invalidURL))
            }
        }
        
        return Future { promise in
            AF.request(url).responseDecodable(of: ImageSearchResultData.self) { dataResponse in
                if case let .success(data) = dataResponse.result {
                    promise(.success(data))
                } else if case let .failure(error) = dataResponse.result {
                    promise(.failure(error))
                }
            }
        }
    }
}
