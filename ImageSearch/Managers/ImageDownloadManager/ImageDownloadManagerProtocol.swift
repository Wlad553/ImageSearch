//
//  File.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 21/06/2023.
//

import UIKit
import Combine

protocol ImageDownloadManagerProtocol: AnyObject {
    @discardableResult
    func downloadImage(withURL url: String, forImageView imageView: UIImageView) -> Future<Void, Error>
}
