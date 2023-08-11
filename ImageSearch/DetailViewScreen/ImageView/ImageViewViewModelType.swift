//
//  ImageViewViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 28/06/2023.
//

import UIKit

protocol ImageViewViewModelType: AnyObject {
    var imageDonwloadManager: ImageDownloadManager { get }
    var imageURL: String { get }
    
    func showCropViewController(withImage image: UIImage)
}
