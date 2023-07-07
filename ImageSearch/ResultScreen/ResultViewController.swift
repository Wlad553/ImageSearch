//
//  ResultViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 14/06/2023.
//

import UIKit
import Combine

final class ResultViewController: UIViewController {
    let viewModel: ResultViewViewModelType
    let searchBarView: SearchBarView
    let resultView = ResultView()
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(searchBarView: SearchBarView, viewModel: ResultViewViewModelType) {
        self.viewModel = viewModel
        self.searchBarView = searchBarView
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
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        resultView.tapGestureRecognizer.addTarget(self, action: #selector(didRecognizeTap))
        resultView.assignImageResultsCollectionViewDelegates(to: self)
        searchBarView.searchTextField.delegate = self
        searchBarView.searchTextField.text = viewModel.currentSearchText
        addNotificationCenterObservers()
        subscribeToSearchBarSelectedFilterUpdate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchBarView.searchTextField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if viewModel.selectedFilterForRecentSearchQuery != searchBarView.viewModel.selectedFilter {
            viewModel.selectedFilterForRecentSearchQuery = searchBarView.viewModel.selectedFilter
            prepareForImageSearch()
        }
    }
    
    // MARK: Subscribtions
    func performSearch() {
        viewModel.fetchData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    resultView.imageResultsCollectionView.reloadData()
                    resultView.imageResultsHeaderView?.relatedCategoriesCollectionView.reloadData()
                    resultView.activityIndicator.stopAnimating()
                    if resultView.imageResultsCollectionView.alpha == 0 {
                        UIView.animate(withDuration: 0.3) {
                            self.resultView.imageResultsCollectionView.alpha = 1
                        }
                    }
                    resultView.noSearchResultsStackView.isHidden = self.viewModel.searchResultData?.hits.count != 0
                case .failure(let error):
                    let message = (error as NSError).code == 13 ? "The Internet connection appears to be offline" : "Please try again later"
                    presentOKAlertController(withTitle: "Search error", message: message) {
                        self.resultView.activityIndicator.stopAnimating()
                    }
                }
            } receiveValue: {}
            .store(in: &subscribers)
    }
    
    func prepareForImageSearch() {
        UIView.animate(withDuration: 0.1) {
            self.resultView.imageResultsCollectionView.alpha = 0
        } completion: { _ in
            self.resultView.imageResultsCollectionView.setContentOffset(.zero, animated: false)
            self.resultView.imageResultsHeaderView?.relatedCategoriesCollectionView.setContentOffset(.zero, animated: false)
        }
        self.resultView.noSearchResultsStackView.isHidden = true
        self.resultView.activityIndicator.startAnimating()
        self.performSearch()
    }
    
    func subscribeToSearchBarSelectedFilterUpdate() {
        searchBarView.viewModel.selectedFilterPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filter in
                guard self?.navigationController?.topViewController == self else { return }
                self?.viewModel.selectedFilterForRecentSearchQuery = filter
                self?.prepareForImageSearch()
            }
            .store(in: &subscribers)
    }
    
    // MARK: ImageShare
    @objc private func didTapShareButton(sender: UIButton) {
        guard let senderSuperview = sender.superview as? ImageResultsCell,
              let largeImageURLString = senderSuperview.viewModel?.largeImageURL,
              let largeImageURL = URL(string: largeImageURLString)
        else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [largeImageURL], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    // MARK: TapGestureRecognizer
    @objc private func didRecognizeTap() {
        searchBarView.searchTextField.resignFirstResponder()
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
            imageResultsCell.shareButton.addTarget(self, action: #selector(didTapShareButton(sender:)), for: .touchUpInside)
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
            viewModel.didTapImageResultCell(atIndexPath: indexPath)
            
        } else if resultView.imageResultsHeaderView?.relatedCategoriesCollectionView == collectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell,
                  cell.categoryLabel.text != searchBarView.searchTextField.text
            else { return }
            let searchText = cell.categoryLabel.text ?? ""
            searchBarView.searchTextField.text = searchText
            viewModel.currentSearchText = searchText
            prepareForImageSearch()
        }
    }
}

// MARK: UIScrollViewDelegate
extension ResultViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if resultView.imageResultsCollectionView.isTracking && searchBarView.searchTextField.isFirstResponder {
            searchBarView.searchTextField.resignFirstResponder()
        }
    }
}

// MARK: UITextFieldDelegate
extension ResultViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if navigationController?.topViewController != self {
            UIView.animate(withDuration: 0.1) {
                self.navigationController?.topViewController?.view.subviews.forEach({ view in
                    view.alpha = 0
                })
            } completion: { _ in
                self.navigationController?.popToViewController(self, animated: false)
            }
        }
        let textFieldText = textField.text ?? ""
        viewModel.currentSearchText = textFieldText
        prepareForImageSearch()
        textField.resignFirstResponder()
        return true
    }
}

// MARK: NotificationCenter
extension ResultViewController {
    private func addNotificationCenterObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotificationTriggered(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotificationTriggered(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardNotificationTriggered(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              searchBarView.searchTextField.isFirstResponder
        else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            resultView.moveNoSearchResultsStackViewUp(keyboardFrame: keyboardFrame)
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            resultView.moveNoSearchResultsStackViewDown()
        }
    }
}
