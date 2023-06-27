//
//  ResultView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 14/06/2023.
//

import UIKit
import SnapKit

final class ResultView: UIView {
    let noSearchResultsStackView = UIStackView()
    let imageResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var imageResultsHeaderView: ImageResultsHeaderView?
    
    override init(frame: CGRect) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            super.init(frame: .zero)
            return
        }
        super.init(frame: windowScene.screen.bounds)
        backgroundColor = .resultViewBackground
        setUpImageResultsCollectionView()
        setUpActivityIndicator()
        setUpNoSearchResultsStackView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignImageResultsCollectionViewDelegates<T>(to delegate: T) where T: UICollectionViewDataSource & UICollectionViewDelegate & UITextFieldDelegate {
        imageResultsCollectionView.dataSource = delegate
        imageResultsCollectionView.delegate = delegate
    }
    
    // MARK: Subviews setup
    private func setUpImageResultsCollectionView() {
        addSubview(imageResultsCollectionView)
        imageResultsCollectionView.setCollectionViewLayout(imageResultsCollectionViewLayout(), animated: false)
        imageResultsCollectionView.backgroundColor = backgroundColor
        imageResultsCollectionView.showsVerticalScrollIndicator = false
        imageResultsCollectionView.delaysContentTouches = false
        imageResultsCollectionView.register(ImageResultsCell.self, forCellWithReuseIdentifier: ImageResultsCell.reuseIdentifier)
        imageResultsCollectionView.register(ImageResultsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageResultsHeaderView.reuseIdentifier)
        imageResultsCollectionView.alpha = 0
    }
    
    private func setUpNoSearchResultsStackView() {
        let noSearchResultsLabel = UILabel()
        let sublabel = UILabel()
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
                
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        noSearchResultsLabel.font = UIFont(name: Fonts.OpenSans.ExtraBold.rawValue, size: 21)
        noSearchResultsLabel.numberOfLines = 0
        noSearchResultsLabel.textAlignment = .center
        noSearchResultsLabel.text = "No results for search query"
        
        sublabel.font = UIFont(name: Fonts.OpenSans.Regular.rawValue, size: 17)
        sublabel.textColor = imageView.tintColor
        sublabel.text = "Check the spelling or try a new search"
        
        [imageView, noSearchResultsLabel, sublabel].forEach { view in
            noSearchResultsStackView.addArrangedSubview(view)
        }
        
        noSearchResultsStackView.axis = .vertical
        noSearchResultsStackView.spacing = 8
        noSearchResultsStackView.distribution = .equalSpacing
        noSearchResultsStackView.alignment = .center
        noSearchResultsStackView.isHidden = true
        
        addSubview(noSearchResultsStackView)
    }
    
    private func setUpActivityIndicator() {
        addSubview(activityIndicator)
    }
    
    // MARK: Subviews constraints
    private func addConstraints() {
        imageResultsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        noSearchResultsStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: ImageResultsCollectionViewLayout
extension ResultView {
    private func imageResultsCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: frame.width - 32, height: (frame.width - 32) / 1.77)
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 88)
        return layout
    }
}

// MARK: Animations
extension ResultView {
    // MARK: View
    func moveNoSearchResultsStackViewUp(keyboardFrame: CGRect) {
        UIView.animate(withDuration: 0.2) {
            self.noSearchResultsStackView.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-keyboardFrame.height / 2.5)
            }
            self.layoutIfNeeded()
        }
    }
    
    func moveNoSearchResultsStackViewDown() {
        UIView.animate(withDuration: 0.2) {
            self.noSearchResultsStackView.snp.updateConstraints { make in
                make.centerY.equalToSuperview()
            }
            self.layoutIfNeeded()
        }
    }
}
