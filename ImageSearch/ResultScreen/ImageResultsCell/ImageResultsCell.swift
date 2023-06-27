//
//  ImageResultsCell.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import UIKit
import SnapKit
import Combine

final class ImageResultsCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageResultCell"
    private var subscriber: AnyCancellable?
    
    let imageView = UIImageView()
    let shareButton = RectangleButton(image: UIImage(named: "shareImage"))
    var viewModel: ImageResultsCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            subscriber = viewModel.imageDownloadManager.downloadImage(withUrl: viewModel.cellImageURL, forImageView: imageView)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    if case .finished = completion {
                        self?.shareButton.isHidden = false
                    }
                } receiveValue: {}
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
        setUpImageView()
        setUpShareButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shareButton.isHidden = true
        imageView.image = nil
    }
    
    // MARK: cell setup
    private func setUpCell() {
        layer.backgroundColor = UIColor.searchTextFieldBackground.cgColor
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowPath = CGPath(rect: CGRect(x: 2, y: 8, width: frame.width - 4, height: frame.height - 12), transform: nil)
    }
    
    // MARK: Subviews setup
    private func setUpImageView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpShareButton() {
        shareButton.isHidden = true
        addSubview(shareButton)
        
        shareButton.imageView?.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        
        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.width.equalTo(40)
        }
    }
}
