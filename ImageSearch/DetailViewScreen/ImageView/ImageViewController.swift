//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 28/06/2023.
//

import UIKit

final class ImageViewController: UIViewController {
    let imageView = ImageView()
    let viewModel: ImageViewViewModelType
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(viewModel: ImageViewViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imageView.scrollView.delegate = self
        viewModel.imageDonwloadManager.downloadImage(withURL: viewModel.imageURL, forImageView: imageView.presentedImageView)
        setUpNavigationControllerGestureRecognizer()
        addTargets()
        setUpNavigationBarButtons()
    }
    
    private func setUpNavigationControllerGestureRecognizer() {
        navigationController?.hidesBarsOnTap = true
        navigationController?.barHideOnTapGestureRecognizer.require(toFail: imageView.doubleTapRecognizer)
        navigationController?.barHideOnTapGestureRecognizer.delaysTouchesBegan = false
    }
        
    private func addTargets() {
        imageView.doubleTapRecognizer.addTarget(self, action: #selector(handleDoubleTap))
        imageView.backButton.addTarget(self, action: #selector(didTapBarLeftButton), for: .touchUpInside)
    }
    
    private func setUpNavigationBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapBarRightButton))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.customView = imageView.backButton
    }
    
    @objc private func didTapBarRightButton() {
        guard let imageToPass = imageView.presentedImageView.image else { return }
        viewModel.showCropViewController(withImage: imageToPass)
    }
    
    @objc private func didTapBarLeftButton() {
        dismiss(animated: true)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if imageView.scrollView.zoomScale == 1 {
            imageView.scrollView.setZoomScale(2, animated: true)
        } else {
            imageView.scrollView.setZoomScale(1, animated: true)
        }
    }
}

// MARK: UIScrollViewDelegate
extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView.presentedImageView
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !scrollView.frame.height.isZero else { return }
        if scrollView.contentOffset.y <= -(scrollView.frame.height * 0.14) && scrollView.panGestureRecognizer.state != .changed && scrollView.zoomScale == 1.0  {
            dismiss(animated: true)
        }
    }
}
