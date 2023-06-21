//
//  ImageSearchData.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Foundation

struct ImageSearchResultData: Decodable {
    let total: Int
    let hits: [Hit]
    
    struct Hit: Decodable {
        let tags: String
        let webformatURL: String // 640x400
        let largeImageURL: String // starting from fullhd
    }
}

