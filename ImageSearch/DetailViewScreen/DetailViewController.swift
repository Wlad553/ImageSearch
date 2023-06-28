//
//  DetailViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 26/06/2023.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    let viewModel: DetailViewViewModelType
    let searchBarView: SearchBarView
    let detailView = DetailView()
    var subscribers: Set<AnyCancellable> = []
    
    init(searchBarView: SearchBarView, viewModel: DetailViewViewModelType) {
        self.viewModel = viewModel
        self.searchBarView = searchBarView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        detailView.imageViewTapGestureRecognizer.addTarget(self, action: #selector(didTapShowImageButton))
        detailView.assignCollectionViewDelegates(to: self)
        subscribeToViewModelChosenHitUpdate()
        subscribeToSearchBarSelectedFilterUpdate()
        addButtonTargets()
    }
    
    func performRelatedPhotosSearch() {
        detailView.relatedPhotosCollectionView.setContentOffset(.zero, animated: true)
        viewModel.fetchData(withFilter: searchBarView.viewModel.selectedFilter)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.detailView.relatedPhotosCollectionView.reloadData()
                case .failure(let error):
                    let message = (error as NSError).code == 13 ? "The Internet connection appears to be offline" : "Please try again later"
                    self?.presentOKAlertController(withTitle: "Search error", message: message)
                }
            } receiveValue: {}
            .store(in: &subscribers)
    }
    
    func subscribeToViewModelChosenHitUpdate() {
        viewModel.chosenHitPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hit in
                guard let self = self else { return }
                let photoExtension = URL(string: viewModel.chosenHit.largeImageURL)?.pathExtension.uppercased() ?? String()
                detailView.viewsLabel.text = "Views: \(viewModel.chosenHit.views)"
                detailView.likesLabel.text = "Likes: \(viewModel.chosenHit.likes)"
                detailView.photoExtensionLabel.text = "Photo in .\(photoExtension) format"
                viewModel.imageDownloadManager.downloadImage(withURL: hit.webFormatURL, forImageView: detailView.detailImageView)
            }
            .store(in: &subscribers)
    }
    
    func subscribeToSearchBarSelectedFilterUpdate() {
        searchBarView.viewModel.selectedFilterPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.performRelatedPhotosSearch()
            }
            .store(in: &subscribers)
    }
    
    private func addButtonTargets() {
        detailView.shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        detailView.downloadButton.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        detailView.showImageButton.addTarget(self, action: #selector(didTapShowImageButton), for: .touchUpInside)
    }
    
    @objc private func didTapShareButton() {
        guard let largeImageURL = URL(string: viewModel.chosenHit.largeImageURL) else { return }
        let activityViewController = UIActivityViewController(activityItems: [largeImageURL], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @objc func didTapDownloadButton() {
        detailView.downloadActivityIndicator.startAnimating()
        viewModel.networkManager.downloadImage(withURL: viewModel.chosenHit.largeImageURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error as NSError) = completion else { return }
                if error.code == 13 {
                    self?.presentOKAlertController(withTitle: "Unable to download image", message: "Internet connection appears to be offline")
                }
            } receiveValue: { [weak self] image in
                
                self?.viewModel.imageSaveManager.onSaveCompletion = { [weak self] error in
                    guard let self = self else { return }
                    if let error = error as? NSError {
                        if error.code == -1 {
                            self.presentOKAlertController(withTitle: "Access Denied",
                                                          message: "Image Search needs access to your photos. You can enable this in your Privacy Settings")
                        }
                    } else {
                        let alertController = UIAlertController(title: "Success", message: "The image has been successfully downloaded to your library", preferredStyle: .alert)
                        present(alertController, animated: true)
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
                            self.dismiss(animated: true)
                        }
                    }
                }
                self?.detailView.downloadActivityIndicator.stopAnimating()
                self?.viewModel.imageSaveManager.writeToPhotoAlbum(image: image)
            }
            .store(in: &subscribers)
    }
    
    @objc func didTapShowImageButton() {
        viewModel.didTapShowImageButton()
    }
}

// MARK: UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfImageResultItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(UICollectionReusableView.self)", for: indexPath)
        detailView.addHeaderView(to: reusableView)
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let imageResultsCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageResultsCell.reuseIdentifier, for: indexPath) as? ImageResultsCell else { return cell }
        imageResultsCell.viewModel = viewModel.imageResultsCellViewModel(at: indexPath)
        imageResultsCell.hidesShareButton = true
        cell = imageResultsCell
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBarView.searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.1) {
            self.detailView.detailImageView.alpha = 0
        }
        UIView.animate(withDuration: 0.1, delay: 0.15) {
            self.detailView.detailImageView.alpha = 1
        }
        detailView.relatedPhotosCollectionView.setContentOffset(.zero, animated: true)
        viewModel.didTapItem(atIndexPath: indexPath)
        performRelatedPhotosSearch()
    }
}

// MARK: UIScrollViewDelegate
extension DetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if detailView.relatedPhotosCollectionView.isTracking && searchBarView.searchTextField.isFirstResponder {
            searchBarView.searchTextField.resignFirstResponder()
        }
    }
}
