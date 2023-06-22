//
//  ImageDownloadManager.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 21/06/2023.
//

import Kingfisher

class ImageDownloadManager: ImageDownloadManagerProtocol {
    func downloadImage(withUrl url: String, forImageView imageView: UIImageView) {
        guard let url = URL(string: url) else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
}
