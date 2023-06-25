//
//  ImageResultsHeaderViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import Foundation

final class ImageResultsHeaderViewViewModel: ImageResultsHeaderViewViewModelType {
    let resultsNumber: Int
    
    init(resultsNumber: Int) {
        self.resultsNumber = resultsNumber
    }
}
