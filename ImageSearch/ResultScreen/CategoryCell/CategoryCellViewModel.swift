//
//  CategoryCellViewModel.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import Foundation

final class CategoryCellViewModel: CategoryCellViewModelType {
    let categoryTitle: String
    
    init(categoryLabelText: String) {
        self.categoryTitle = categoryLabelText
    }
}
