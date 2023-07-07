//
//  ImageViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 28/06/2023.
//

import Foundation

final class ImageViewViewModel: ImageViewViewModelType {
    let imageDonwloadManager: ImageDownloadManager
    let imageURL: String
    
    init(imageDonwloadManager: ImageDownloadManager, imageURL: String) {
        self.imageDonwloadManager = imageDonwloadManager
        self.imageURL = imageURL
    }
}
