//
//  ImageResultCellViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 19/06/2023.
//

import UIKit

protocol ImageResultsCellViewModelType: AnyObject {
    var cellImageURL: String { get }
    var imageDownloadManager: ImageDownloadManagerProtocol { get }
}
