//
//  ImageResultsCell.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import UIKit

final class ImageResultsCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageResultCell"
    
    let imageView = UIImageView()
    var viewModel: ImageResultsCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            imageView.image = viewModel.cellImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell() {
        imageView.contentMode = .scaleAspectFit
        layer.backgroundColor = UIColor.imagePlaceholderBackground.cgColor
        layer.cornerRadius = 5
        addSubview(imageView)
        imageView.activateEqualToSuperviewConstraints()
    }
}
