//
//  ResultViewViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 16/06/2023.
//

import Foundation

final class ResultViewViewModel: ResultViewViewModelType {
    let testArray = ["Forest Background", "Tree", "Nature", "World"]
    
    func numberOfImageResultItems() -> Int {
        testArray.count
    }
    
    func numberOfRelatedCategoryItems() -> Int {
        testArray.count
    }
    
    func categoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelType {
        return CategoryCellViewModel(categoryLabelText: testArray[indexPath.row])
    }
}
