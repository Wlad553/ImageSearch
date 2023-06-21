//
//  ImageResultCellViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import UIKit

final class ImageResultsCellViewModel: ImageResultsCellViewModelType {
    var cellImageURL: String
    let imageDownloadManager: ImageDownloadManagerProtocol
    
    init(cellImageURL: String, imageDownloadManager: ImageDownloadManagerProtocol) {
        self.cellImageURL = cellImageURL
        self.imageDownloadManager = imageDownloadManager
    }
}
