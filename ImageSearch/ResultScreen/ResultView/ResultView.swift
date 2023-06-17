//
//  ResultView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 14/06/2023.
//

import UIKit
import SnapKit

final class ResultView: UIView {
     let topView = UIView()
    private let topStackView = UIStackView()
    let headerStackView = UIStackView()
    
    let resultNumberLabel = UILabel()
    let categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let logoLabel = UILabel()
    let searchTextField = SearchTextField()
    let optionsButton = UIButton()
    let resultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
        setUpHeaderStackView()
        setUpResultNumberLabel()
        setUpCategoriesCollectionView()
        setUpResultsCollectionView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        logoLabel.font = UIFont(name: "Pattaya-Regular", size: 36)
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
    
    // MARK: HeaderStackView
    private func setUpHeaderStackView() {
        headerStackView.axis = .vertical
        headerStackView.spacing = 8
        headerStackView.alignment = .fill
        headerStackView.distribution = .fillEqually
        
        headerStackView.addArrangedSubview(resultNumberLabel)
        headerStackView.addArrangedSubview(categoriesCollectionView)
    }
    
    private func setUpResultNumberLabel() {
        resultNumberLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        resultNumberLabel.textColor = .black
        resultNumberLabel.textAlignment = .left
        resultNumberLabel.numberOfLines = 1
        resultNumberLabel.layer.transform = CATransform3DMakeTranslation(16, 0, 0)
        resultNumberLabel.text = "xxx xxx Free Images"
    }
    
    private func setUpCategoriesCollectionView() {
        categoriesCollectionView.setCollectionViewLayout(setUpCategoriesCollectionViewLayout(), animated: false)
        categoriesCollectionView.backgroundColor = .searchTextFieldBackground
        categoriesCollectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: ResultsCollectionView
    private func setUpResultsCollectionView() {
        resultsCollectionView.setCollectionViewLayout(setUpResultsCollectionViewLayout(), animated: false)
        resultsCollectionView.backgroundColor = .searchTextFieldBackground
        resultsCollectionView.showsVerticalScrollIndicator = false
        addSubview(resultsCollectionView)
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
        
        resultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp_bottomMargin).offset(9)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: UICollectionView Layouts
extension ResultView {
    private func setUpResultsCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: frame.width - 32, height: 200) // размер ячейки
        layout.minimumLineSpacing = 16
//        layout.sectionInset = .init(top: 12, left: 0, bottom: 0, right: 0) // отступы секции от краев
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 80) // размеры секций
        return layout
    }
    
    private func setUpCategoriesCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 32, height: 24)
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 16
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = CGSize(width: 72, height: 24)
        return layout
    }
}
