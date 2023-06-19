//
//  ImageResultsHeaderView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import UIKit

final class ImageResultsHeaderView: UICollectionReusableView {
    static let categoriesHeaderReuseIdentifier = "CategoriesHeader"
    static let reuseIdentifier = "ImageResultsHeader"
    
    private let stackView = UIStackView()
    let resultsNumberLabel = UILabel()
    let relatedCategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var viewModel: ImageResultsHeaderViewViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            let numberFormatter = NumberFormatter()
            numberFormatter.groupingSeparator = " "
            numberFormatter.numberStyle = .decimal
            if let formattedResultsNumber = numberFormatter.string(from: NSNumber(value: viewModel.resultsNumber)) {
                resultsNumberLabel.text = "\(formattedResultsNumber) Free Images"
            } else {
                resultsNumberLabel.text = "0 Free Images"
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHeaderStackView()
        setUpResultNumberLabel()
        setUpRelatedCategoriesCollectionView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpHeaderViewForRelatedCategoriesCollectionView(superview: UIView) {
        let label = UILabel()
        label.textColor = .optionsButton
        label.numberOfLines = 1
        label.font = UIFont(name: Fonts.OpenSans.Regular.rawValue, size: 14)
        label.text = "Related"
        superview.addSubview(label)
        label.activateEqualToSuperviewConstraints(leadingOffset: 16)
    }
    
    private func setUpHeaderStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(resultsNumberLabel)
        stackView.addArrangedSubview(relatedCategoriesCollectionView)
        addSubview(stackView)
    }
    
    private func setUpResultNumberLabel() {
        resultsNumberLabel.font = UIFont(name: Fonts.OpenSans.SemiBold.rawValue, size: 18)
        resultsNumberLabel.textColor = .black
        resultsNumberLabel.textAlignment = .left
        resultsNumberLabel.numberOfLines = 1
        resultsNumberLabel.layer.transform = CATransform3DMakeTranslation(16, 0, 0)
    }
    
    // MARK: RelatedCategoriesCollectionView
    private func setUpRelatedCategoriesCollectionView() {
        relatedCategoriesCollectionView.setCollectionViewLayout(relatedCategoriesCollectionViewLayout(), animated: false)
        relatedCategoriesCollectionView.backgroundColor = .searchTextFieldBackground
        relatedCategoriesCollectionView.showsHorizontalScrollIndicator = false
        relatedCategoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        relatedCategoriesCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageResultsHeaderView.categoriesHeaderReuseIdentifier)
    }
    
    // MARK: Constraints
    private func addConstraints() {
        relatedCategoriesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(frame.width)
        }
        stackView.activateEqualToSuperviewConstraints(topOffset: 8, bottomOffset: -16)
    }
}

// MARK: RelatedCategoriesCollectionViewLayout
extension ImageResultsHeaderView {
    private func relatedCategoriesCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 32, height: 32)
        layout.minimumLineSpacing = 8
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout.headerReferenceSize = CGSize(width: 72, height: 24)
        return layout
    }
}
