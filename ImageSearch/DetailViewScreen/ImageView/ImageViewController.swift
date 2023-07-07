//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 28/06/2023.
//

import UIKit

final class ImageViewController: UIViewController {
    let scrollView = UIScrollView()
    let presentedImageView = UIImageView()
    let doubleTapRecognizer = UITapGestureRecognizer()
    let viewModel: ImageViewViewModel
    
    init(viewModel: ImageViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpDoubleTapGestureRecognizer()
        setUpScrollView()
        setUpImageView()
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.setZoomScale(2, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    private func setUpDoubleTapGestureRecognizer() {
        doubleTapRecognizer.addTarget(self, action: #selector(handleDoubleTap))
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        doubleTapRecognizer.numberOfTapsRequired = 2
    }
    
    private func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpImageView() {
        viewModel.imageDonwloadManager.downloadImage(withURL: viewModel.imageURL, forImageView: presentedImageView)
        scrollView.addSubview(presentedImageView)
        presentedImageView.backgroundColor = .black
        presentedImageView.contentMode = .scaleAspectFit
        presentedImageView.frame.size = scrollView.contentSize
        presentedImageView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.centerY.height.equalToSuperview().offset(-32)
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return presentedImageView
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -(scrollView.frame.height * 0.14) && scrollView.panGestureRecognizer.state != .changed && scrollView.zoomScale == 1.0  {
            dismiss(animated: true)
        }
    }
}
