//
//  ImageView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 13/07/2023.
//

import UIKit

final class ImageView: UIView {
    let scrollView = UIScrollView()
    let presentedImageView = UIImageView()
    let backButton = UIButton(type: .system)
    
    let doubleTapRecognizer = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            super.init(frame: .zero)
            return
        }
        super.init(frame: windowScene.screen.bounds)
        backgroundColor = .black
        setUpBackButton()
        setUpDoubleTapGestureRecognizer()
        setUpScrollView()
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackButton() {
        backButton.tintColor = .white
        backButton.setTitle("Back", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    }
    
    private func setUpDoubleTapGestureRecognizer() {
        doubleTapRecognizer.delaysTouchesBegan = false
        addGestureRecognizer(doubleTapRecognizer)
        doubleTapRecognizer.numberOfTapsRequired = 2
    }
    
    private func setUpScrollView() {
        addSubview(scrollView)
        scrollView.delaysContentTouches = false
        scrollView.gestureRecognizers?.forEach({ recognizer in
            recognizer.delaysTouchesBegan = false
        })
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
                
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpImageView() {
        scrollView.addSubview(presentedImageView)
        presentedImageView.backgroundColor = .black
        presentedImageView.contentMode = .scaleAspectFit
        
        presentedImageView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.centerY.equalToSuperview().offset(-64)
            make.height.equalToSuperview().offset(-128)
        }
    }
}
