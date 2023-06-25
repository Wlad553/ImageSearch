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
        enum ImageType: String {
            case all = "&image_type=all"
            case photo = "&image_type=photo"
            case vector = "&image_type=vector"
        }
    }
}

class NetworkManager: NetworkManagerProtocol {
    enum NMError: Error {
        case invalidURL
    }
    
    func fetchData(withSearchQuery searchQuery: String, maxResultNumber: Int) -> Future<ImageSearchResultData, Error> {
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(searchQuery)
        let dominantLanguage = languageRecognizer.dominantLanguage?.rawValue ?? "en"
        let encodedText = searchQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let urlString = "https://pixabay.com/api/?key=\(ImageSearchAPI.apiKey.rawValue)&q=\(encodedText)&lang=\(dominantLanguage)&per_page=\(maxResultNumber)"
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(NMError.invalidURL))
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
