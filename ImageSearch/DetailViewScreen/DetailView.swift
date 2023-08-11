//
//  DetailView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 26/06/2023.
//

import UIKit

final class DetailView: UIView {
    private let chosenImageView = UIView()
    private let descriptionStackView = UIStackView()
    
    let relatedPhotosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    let detailImageView = UIImageView()
    let shareButton = UIButton(type: .system)
    let photoExtensionLabel = UILabel()
    let imageLicenseLabel = UILabel()
    let viewsLabel = UILabel()
    let likesLabel = UILabel()
    let showImageButton = RectangleButton(image: UIImage(systemName: "plus.magnifyingglass"))
    let downloadButton = BlueButton(title: "Download",
                                    image: UIImage(named: "downloadButton"))
    
    let downloadActivityIndicator = UIActivityIndicatorView(style: .medium)
    
    let imageViewTapGestureRecognizer = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            super.init(frame: .zero)
            return
        }
        super.init(frame: windowScene.screen.bounds)
        backgroundColor = .resultViewBackground
        setUpDetailImageView()
        setUpDescriptionView()
        setUpLabels()
        setUpShareButton()
        setUpDownloadButton()
        setUpCollectionView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignCollectionViewDelegates<T>(to delegate: T) where T: UICollectionViewDataSource & UICollectionViewDelegate {
        relatedPhotosCollectionView.dataSource = delegate
        relatedPhotosCollectionView.delegate = delegate
    }
    
    //MARK: Subviews setup
    private func setUpDetailImageView() {
        chosenImageView.addSubview(detailImageView)
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.clipsToBounds = true
        detailImageView.isUserInteractionEnabled = true
        detailImageView.backgroundColor = .black
        detailImageView.addSubview(showImageButton)
        detailImageView.addGestureRecognizer(imageViewTapGestureRecognizer)
    }
    
    private func setUpDescriptionView() {
        chosenImageView.addSubview(descriptionStackView)
        chosenImageView.backgroundColor = .white
        
        let lhsVerticalStackView = UIStackView(arrangedSubviews: [
            imageLicenseLabel,
            viewsLabel,
            likesLabel
        ])
        lhsVerticalStackView.axis = .vertical
        lhsVerticalStackView.spacing = 8
        lhsVerticalStackView.alignment = .leading
        lhsVerticalStackView.distribution = .equalSpacing
        
        let rhsVerticalStackView = UIStackView(arrangedSubviews: [
            photoExtensionLabel,
            shareButton
        ])
        rhsVerticalStackView.axis = .vertical
        rhsVerticalStackView.spacing = 12
        rhsVerticalStackView.alignment = .fill
        rhsVerticalStackView.distribution = .fill
        
        let topHorizontalStackView = UIStackView(arrangedSubviews: [
            lhsVerticalStackView,
            rhsVerticalStackView
        ])
        topHorizontalStackView.axis = .horizontal

        descriptionStackView.addArrangedSubview(topHorizontalStackView)
        descriptionStackView.addArrangedSubview(downloadButton)
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 24
        descriptionStackView.alignment = .fill
        descriptionStackView.distribution = .equalSpacing
    }
    
    private func setUpLabels() {
        imageLicenseLabel.text = "Royalty Free License"
        imageLicenseLabel.font = UIFont(name: Fonts.OpenSans.regular.rawValue, size: 17)
        imageLicenseLabel.textAlignment = .left
        imageLicenseLabel.textColor = .searchButtonBackground
        
        [viewsLabel, likesLabel].forEach { label in
            label.font = UIFont(name: Fonts.OpenSans.regular.rawValue, size: 15)
            label.textAlignment = .left
            label.textColor = .optionsButton
        }
        
        photoExtensionLabel.font = UIFont(name: Fonts.OpenSans.regular.rawValue, size: 15)
        photoExtensionLabel.textAlignment = .right
        photoExtensionLabel.textColor = .nightRider
    }
    
    private func setUpShareButton() {
        shareButton.titleLabel?.font = UIFont(name: Fonts.OpenSans.regular.rawValue, size: 14)
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.nightRider, for: .normal)
        
        shareButton.setImage(UIImage(named: "shareImage"), for: .normal)
        shareButton.tintColor = .nightRider
        shareButton.imageView?.contentMode = .scaleAspectFit
        
        if #available(iOS 15.0, *) {
            var buttonConfiguration = UIButton.Configuration.plain()
            buttonConfiguration.imagePadding = 10
            shareButton.configuration = buttonConfiguration
        } else {
            shareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = UIColor.searchButtonBackground.cgColor
        shareButton.layer.cornerRadius = 5
    }
    
    private func setUpDownloadButton() {
        downloadButton.imageView?.layer.transform = CATransform3DMakeTranslation(-6, 0, 0)
        downloadButton.addSubview(downloadActivityIndicator)
        downloadActivityIndicator.color = .nightRider
    }
    
    private func setUpCollectionView() {
        addSubview(relatedPhotosCollectionView)
        relatedPhotosCollectionView.setCollectionViewLayout(relatedPhotosCollectionViewLayout(), animated: false)
        relatedPhotosCollectionView.backgroundColor = .resultViewBackground
        relatedPhotosCollectionView.showsVerticalScrollIndicator = false
        relatedPhotosCollectionView.delaysContentTouches = false
        relatedPhotosCollectionView.register(ImageResultsCell.self, forCellWithReuseIdentifier: ImageResultsCell.reuseIdentifier)
        relatedPhotosCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(UICollectionReusableView.self)")
        relatedPhotosCollectionView.alpha = 1
    }
    
    // MARK: Subviews constraints
    private func addConstraints() {
        detailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(frame.width)
            make.height.equalTo(frame.width / (16/10))
        }
        
        showImageButton.imageView?.snp.makeConstraints({ make in
            make.height.equalTo(25)
            make.width.equalTo(30)
        })
        
        showImageButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-12)
            make.height.width.equalTo(40)
        }
        
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(detailImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
        
        shareButton.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        downloadActivityIndicator.snp.makeConstraints { make in
            make.trailing.equalTo(downloadButton.titleLabel!.snp.leading).offset(-36)
            make.centerY.equalToSuperview()
        }
        
        relatedPhotosCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: ImageResultsCollectionView layout
extension DetailView {
    private func relatedPhotosCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: frame.width / 2 - 24, height: (frame.width / 2 - 48) / (16/10))
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 216 + frame.width / (16/10))
        return layout
    }
    
    func addHeaderView(to view: UIView) {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Fonts.OpenSans.semiBold.rawValue, size: 18)
        label.text = "Related"
        
        view.addSubview(chosenImageView)
        view.addSubview(label)

        chosenImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(chosenImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
    }
}
