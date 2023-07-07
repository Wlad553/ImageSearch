//
//  ImageDownloadManager.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 21/06/2023.
//

import Kingfisher
import Combine

enum KingfisherError: Error {
    case imageToDataEncoding
}

class ImageDownloadManager: ImageDownloadManagerProtocol {
    @discardableResult
    func downloadImage(withURL url: String, forImageView imageView: UIImageView) -> Future<Void, Error> {
        guard let url = URL(string: url) else {
            return Future { promise in
                promise(.failure(NMError.invalidURL))
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
