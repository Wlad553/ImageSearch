//
//  ImageSaveManagerProtocol.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 29/06/2023.
//

import UIKit

protocol ImageSaveManagerProtocol: NSObject {
    var onSaveCompletion: ((Error?) -> Void)? { get set }
    func writeToPhotoAlbum(image: UIImage)
    func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
}
