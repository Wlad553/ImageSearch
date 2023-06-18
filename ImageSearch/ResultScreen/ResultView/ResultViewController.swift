//
//  ResultViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 14/06/2023.
//

import UIKit

final class ResultViewController: UIViewController {
    let viewModel: ResultViewViewModelType
    let resultView = ResultView()
    
    init(viewModel: ResultViewViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = resultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        resultView.assignCollectionViewsDelegates(to: self)
    }
}

// MARK: UICollectionViewDataSource
extension ResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItemsInSection = 0

        if collectionView == resultView.imageResultsCollectionView {
            numberOfItemsInSection = viewModel.numberOfImageResultItems()
        } else if resultView.imageResultsHeaderView?.relatedCategoriesCollectionView == collectionView {
            numberOfItemsInSection = viewModel.numberOfRelatedCategoryItems()
        }
        
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view = UICollectionReusableView()
        guard kind == UICollectionView.elementKindSectionHeader else { return view }
        
        if collectionView == resultView.imageResultsCollectionView {
            guard let imageResultsHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageResultsHeaderView.reuseIdentifier, for: indexPath) as? ImageResultsHeaderView else { return view }
            imageResultsHeader.relatedCategoriesCollectionView.delegate = self
            imageResultsHeader.relatedCategoriesCollectionView.dataSource = self
            resultView.imageResultsHeaderView = imageResultsHeader
            view = imageResultsHeader
        } else if resultView.imageResultsHeaderView?.relatedCategoriesCollectionView == collectionView {
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageResultsHeaderView.categoriesHeaderReuseIdentifier, for: indexPath)
            resultView.imageResultsHeaderView?.setUpHeaderViewForRelatedCategoriesCollectionView(superview: view)
        }
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == resultView.imageResultsCollectionView {
            guard let imageResultCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageResultCell.reuseIdentifier, for: indexPath) as? ImageResultCell else { return cell }
            cell = imageResultCell
        } else if resultView.imageResultsHeaderView?.relatedCategoriesCollectionView == collectionView {
            guard let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { return cell }
            categoryCell.viewModel = viewModel.categoryCellViewModel(at: indexPath)
            cell = categoryCell
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ResultViewController: UICollectionViewDelegate {
}

// MARK: UIScrollViewDelegate
extension ResultViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if resultView.imageResultsCollectionView.isTracking && resultView.searchTextField.isFirstResponder {
            resultView.searchTextField.resignFirstResponder()
        }
    }
}
