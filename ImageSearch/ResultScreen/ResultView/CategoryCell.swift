//
//  CategoryCell.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    let categoryLabel = UILabel()
    var viewModel: CategoryCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            categoryLabel.text = viewModel.categoryTitle
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
        setUpCategoryLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCell() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.imagePlaceholderBackground.cgColor
        layer.cornerRadius = 3
        layer.backgroundColor = UIColor.border.cgColor
    }
    
    private func setUpCategoryLabel() {
        categoryLabel.textColor = .black
        categoryLabel.text = "Forest Background"
        categoryLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center
        categoryLabel.numberOfLines = 1
        addSubview(categoryLabel)
        categoryLabel.activateEqualToSuperviewConstraints(topOffset: 4, bottomOffset: -4, leadingOffset: 12, trailingOffset: -12)
    }
}
