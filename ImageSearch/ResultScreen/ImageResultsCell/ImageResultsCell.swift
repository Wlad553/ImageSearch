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
            viewModel.imageDownloadManager.downloadImage(withUrl: viewModel.cellImageURL, forImageView: imageView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCell() {
        layer.backgroundColor = UIColor.searchTextFieldBackground.cgColor
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowPath = CGPath(rect: CGRect(x: 2, y: 8, width: frame.width - 4, height: frame.height - 12), transform: nil)
        
        addSubview(imageView)
        imageView.activateEqualToSuperviewConstraints()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
    }
}
