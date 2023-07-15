//
//  ImageViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 28/06/2023.
//

import Foundation
import XCoordinator

final class ImageViewViewModel: ImageViewViewModelType {
    private let router: WeakRouter<AppRoute>
    let imageDonwloadManager: ImageDownloadManager
    let imageURL: String
    
    init(router: WeakRouter<AppRoute>, imageDonwloadManager: ImageDownloadManager, imageURL: String) {
        self.router = router
        self.imageDonwloadManager = imageDonwloadManager
        self.imageURL = imageURL
    }
    
    func showCropViewController(withImage image: UIImage) {
        router.trigger(.crop(image: image))
    }
}
