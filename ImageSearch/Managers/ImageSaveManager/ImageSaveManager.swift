//
//  ImageSaveManager.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 28/06/2023.
//

import UIKit

class ImageSaveManager: NSObject, ImageSaveManagerProtocol {
    var onSaveCompletion: ((Error?) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        onSaveCompletion?(error)
    }
}
