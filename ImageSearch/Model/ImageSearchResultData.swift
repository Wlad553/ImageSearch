//
//  ImageSearchData.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Foundation

struct ImageSearchResultData: Decodable {
    enum Separator: String {
        case tagsSeparator = ", "
    }
    
    let total: Int
    var hits: [Hit]
    
    struct Hit: Decodable {
        let id: Int
        let tags: String
        let views: Int
        let likes: Int
        let webFormatURL: String
        let largeImageURL: String
        
        enum CodingKeys: String, CodingKey {
            case id, tags, largeImageURL, views, likes
            case webFormatURL = "webformatURL"
        }
    }
}

