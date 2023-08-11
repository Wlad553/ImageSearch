//
//  DetailViewViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 26/06/2023.
//

import Foundation
import Combine

protocol DetailViewViewModelType: AnyObject {
    var networkManager: NetworkManagerProtocol { get }
    var imageDownloadManager: ImageDownloadManagerProtocol { get }
    var imageSaveManager: ImageSaveManagerProtocol { get }
    var chosenHit: ImageSearchResultData.Hit { get }
    var chosenHitPublisher: Published<ImageSearchResultData.Hit>.Publisher { get }
    var searchResultData: ImageSearchResultData? { get }
    
    func fetchData(withFilter order: ImageSearchAPI.QueryParameters.Order) -> Future<Void, Error>
    func didTapItem(atIndexPath indexPath: IndexPath)
    func didTapShowImageButton()
    func numberOfImageResultItems() -> Int
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType?
}
