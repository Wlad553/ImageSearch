//
//  ResultView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 14/06/2023.
//

import UIKit
import SnapKit

final class ResultView: UIView {
    private let topView = UIView()
    private let topStackView = UIStackView()
    
    let logoLabel = UILabel()
    let searchTextField = SearchTextField()
    let optionsButton = UIButton()
    let imageResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var imageResultsHeaderView: ImageResultsHeaderView?
    
    override init(frame: CGRect) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            super.init(frame: .zero)
            return
        }
        super.init(frame: windowScene.screen.bounds)
        backgroundColor = .white
        setUpTopView()
        setUpLogoLabel()
        setUpSearchTextField()
        setUpOptionsButton()
        setUpImageResultsCollectionView()
        setUpActivityIndicator()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignCollectionViewsDelegates<T>(to delegate: T) where T: UICollectionViewDataSource & UICollectionViewDelegate {
        imageResultsCollectionView.dataSource = delegate
        imageResultsCollectionView.delegate = delegate
    }
    
    // MARK: TopView
    private func setUpTopView() {
        let innerStackView = UIStackView(arrangedSubviews: [searchTextField, optionsButton])
        innerStackView.axis = .horizontal
        innerStackView.spacing = 8
        innerStackView.alignment = .fill
        innerStackView.distribution = .equalSpacing
        
        addSubview(topView)
        topView.addSubview(topStackView)
        topStackView.addArrangedSubview(logoLabel)
        topStackView.addArrangedSubview(innerStackView)
        topStackView.axis = .horizontal
        topStackView.spacing = 16
        topStackView.alignment = .center
        topStackView.distribution = .equalCentering

        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.border.cgColor
        bottomLine.frame = CGRect(x: 0, y: 64,
                                  width: frame.width, height: 1)
        topView.layer.addSublayer(bottomLine)
    }
    
    private func setUpLogoLabel() {
        logoLabel.text = "P"
        logoLabel.textAlignment = .center
        logoLabel.font = UIFont(name: Fonts.Pattaya.Regular.rawValue, size: 36)
        logoLabel.textColor = .white
        logoLabel.layer.backgroundColor = UIColor.searchButtonBackground.cgColor
        logoLabel.layer.cornerRadius = 5
    }
    
    private func setUpSearchTextField() {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.border.cgColor
    }
    
    private func setUpOptionsButton() {
        optionsButton.layer.borderColor = UIColor.border.cgColor
        optionsButton.layer.borderWidth = 1
        optionsButton.layer.cornerRadius = 5
        optionsButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        
        optionsButton.imageView?.snp.makeConstraints { make in
            make.height.width.equalTo(32)
        }
        
        optionsButton.tintColor = .optionsButton
    }
    
    // MARK: ResultsCollectionView
    private func setUpImageResultsCollectionView() {
        imageResultsCollectionView.setCollectionViewLayout(imageResultsCollectionViewLayout(), animated: false)
        imageResultsCollectionView.backgroundColor = .searchTextFieldBackground
        imageResultsCollectionView.showsVerticalScrollIndicator = false
        imageResultsCollectionView.register(ImageResultsCell.self, forCellWithReuseIdentifier: ImageResultsCell.reuseIdentifier)
        imageResultsCollectionView.register(ImageResultsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageResultsHeaderView.reuseIdentifier)
        addSubview(imageResultsCollectionView)
    }
    
    private func setUpActivityIndicator() {
        imageResultsCollectionView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    // MARK: Constraints
    private func addConstraints() {
        topView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview { constraintView in
                constraintView.safeAreaLayoutGuide
            }
        }
        
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview().offset(-12)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.height.width.equalTo(52)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        optionsButton.snp.makeConstraints { make in
            make.height.width.equalTo(52)
        }
        
        imageResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp_bottomMargin).offset(9)
            make.leading.trailing.bottom.equalToSuperview()
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
        layout.itemSize = CGSize(width: frame.width - 32, height: 220)
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 88)
        return layout
    }
}
