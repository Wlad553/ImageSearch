//
//  ImageResultCellViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import UIKit

final class ImageResultsCellViewModel: ImageResultsCellViewModelType {
    var cellImage: UIImage
    
    init(image: UIImage) {
        self.cellImage = image
    }
}
