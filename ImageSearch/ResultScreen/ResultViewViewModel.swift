//
//  ResultViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 16/06/2023.
//

import UIKit

final class ResultViewViewModel: ResultViewViewModelType {
    var categoriesArray = ["Forest Background", "Tree", "Nature", "World"]
    var imagesArray = [UIImage(named: "ImagePlaceholder"), UIImage(named: "ImagePlaceholder"), UIImage(named: "ImagePlaceholder")]
    var resultsNumber = 345456
    
    // MARK: UICollectionViewDataSource data
    func numberOfImageResultItems() -> Int {
        imagesArray.count
    }
    
    func numberOfRelatedCategoryItems() -> Int {
        categoriesArray.count
    }
    
    // MARK: ViewModels
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelType {
        return CategoryCellViewModel(categoryLabelText: categoriesArray[indexPath.row])
    }
    
    func imageResultsCellViewModel(at indexPath: IndexPath) -> ImageResultsCellViewModelType {
        return ImageResultsCellViewModel(image: imagesArray[indexPath.row]!)
    }
    
    func imageResultsHeaderViewViewModel() -> ImageResultsHeaderViewViewModelType {
        return ImageResultsHeaderViewViewModel(resultsNumber: resultsNumber)
    }
}
