//
//  ImageDownloadManager.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 21/06/2023.
//

import Kingfisher
import Combine

class ImageDownloadManager: ImageDownloadManagerProtocol {
    func downloadImage(withUrl url: String, forImageView imageView: UIImageView) -> Future<Void, Error> {
        guard let url = URL(string: url) else {
            return Future { promise in
                promise(.failure(NetworkError.invalidURL))
            }
        }
        
        return Future { promise in
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url) { result in
                if case .success = result {
                    promise(.success(Void()))
                }
            }
        }
    }
}
