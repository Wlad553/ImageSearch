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

enum NMError: Error {
    case invalidURL
    case imageDataDecoding
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
                promise(.failure(NMError.invalidURL))
            }
        }
        
        return Future { promise in
            AF.request(url).responseDecodable(of: ImageSearchResultData.self) { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    func downloadImage(withURL url: String) -> Future<UIImage, Error> {
        guard let url = URL(string: url) else {
            return Future { promise in
                promise(.failure(NMError.invalidURL))
            }
        }
        
        return Future { promise in
            AF.request(url).responseData { responseData in
                if let error = responseData.error {
                    promise(.failure(error))
                }
                
                guard let data = responseData.data,
                      let image = UIImage(data: data)
                else {
                    promise(.failure(NMError.imageDataDecoding))
                    return
                }
                promise(.success(image))
            }
        }
    }
}
