//
//  ImageResultCellViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import UIKit

final class ImageResultsCellViewModel: ImageResultsCellViewModelType {
    let cellImageURL: String
    let largeImageURL: String
    let imageDownloadManager: ImageDownloadManagerProtocol
    
    init(cellImageURL: String, fullImageURL: String, imageDownloadManager: ImageDownloadManagerProtocol) {
        self.cellImageURL = cellImageURL
        self.largeImageURL = fullImageURL
        self.imageDownloadManager = imageDownloadManager
    }
}
