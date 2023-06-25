//
//  ResultViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 14/06/2023.
//

import UIKit
import Combine
import Alamofire

final class ResultViewController: UIViewController {
    let viewModel: ResultViewViewModelType
    let resultView = ResultView()
    private var subscribers: [AnyCancellable] = []
    
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
        resultView.assignDelegates(to: self)
        resultView.searchTextField.text = viewModel.currentSearchText
        prepareForImageSearch()
    }
    
    func performSearch(onSuccess: @escaping () -> Void) {
        viewModel.fetchData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    onSuccess()
                case .failure(let error):
                    let message = (error as NSError).code == 13 ? "The Internet connection appears to be offline" : "Please try again later"
                    presentOKAlertController(withTitle: "Search error",
                                             message: message) {
                        self.resultView.activityIndicator.stopAnimating()
                    }
                }
            } receiveValue: {}
            .store(in: &subscribers)
    }
    
    func prepareForImageSearch() {
        viewModel.cleanSearchResultData()
        var activityIndicatorShouldStartAnimating = true
        UIView.animate(withDuration: 0.2) {
            self.resultView.imageResultsCollectionView.alpha = 0
        } completion: { _ in
            self.resultView.imageResultsCollectionView.setContentOffset(.zero, animated: false)
            self.resultView.imageResultsHeaderView?.relatedCategoriesCollectionView.setContentOffset(.zero, animated: false)
            if activityIndicatorShouldStartAnimating {
                self.resultView.noSearchResultsStackView.isHidden = true
                self.resultView.activityIndicator.startAnimating()
            }
        }
        
        self.performSearch(onSuccess: {
            self.resultView.imageResultsCollectionView.reloadData()
            self.resultView.imageResultsHeaderView?.relatedCategoriesCollectionView.reloadData()
            activityIndicatorShouldStartAnimating = false
            self.resultView.activityIndicator.stopAnimating()
            if self.resultView.imageResultsCollectionView.alpha == 0 {
                UIView.animate(withDuration: 0.3) {
                    self.resultView.imageResultsCollectionView.alpha = 1
                }
            }
            self.resultView.noSearchResultsStackView.isHidden = self.viewModel.searchResultData?.hits.count != 0
        })
    }
    
    private func insertNewItems() {
        let oldResultsNumber = resultView.imageResultsCollectionView.numberOfItems(inSection: 0)
        let numberOfNewResults = viewModel.numberOfImageResultItems()
        let indexPathsToInsert = Array(oldResultsNumber..<numberOfNewResults).map { item in
            IndexPath(item: item, section: 0)
        }
        if oldResultsNumber != numberOfNewResults {
            resultView.imageResultsCollectionView.insertItems(at: indexPathsToInsert)
            resultView.imageResultsCollectionView.reloadItems(at: indexPathsToInsert)
        }
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
            imageResultsHeader.viewModel = viewModel.imageResultsHeaderViewViewModel()
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
            guard let imageResultsCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageResultsCell.reuseIdentifier, for: indexPath) as? ImageResultsCell else { return cell }
            imageResultsCell.viewModel = viewModel.imageResultsCellViewModel(at: indexPath)
            cell = imageResultsCell
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == resultView.imageResultsCollectionView {
        } else if resultView.imageResultsHeaderView?.relatedCategoriesCollectionView == collectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell,
                  cell.categoryLabel.text != resultView.searchTextField.text
            else { return }
            let searchText = cell.categoryLabel.text ?? ""
            resultView.searchTextField.text = searchText
            viewModel.currentSearchText = searchText
            prepareForImageSearch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfImageResultItems() - 2 {
            guard let hitsCount = viewModel.searchResultData?.hits.count,
                  hitsCount <= 195
            else { return }
            performSearch(onSuccess: {
                self.insertNewItems()
            })
        }
    }
}

// MARK: UIScrollViewDelegate
extension ResultViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if resultView.imageResultsCollectionView.isTracking && resultView.searchTextField.isFirstResponder {
            resultView.searchTextField.resignFirstResponder()
        }
    }
}

// MARK: UITextFieldDelegate
extension ResultViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldText = textField.text ?? ""
        viewModel.currentSearchText = textFieldText
        prepareForImageSearch()
        textField.resignFirstResponder()
        return true
    }
}
