//
//  ResultViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 14/06/2023.
//

import UIKit

final class ResultViewController: UIViewController {
    let viewModel = ResultViewViewModel()
    let resultView = ResultView()
    let testArray = ["123", "234", "345", "234", "234", "234", "234", "234"]
    
    override func loadView() {
        super.loadView()
        view = resultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        resultView.categoriesCollectionView.dataSource = self
        resultView.categoriesCollectionView.delegate = self
        resultView.resultsCollectionView.dataSource = self
        resultView.resultsCollectionView.delegate = self
        resultView.categoriesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "label")
        resultView.categoriesCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoriesHeader")
        resultView.resultsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageViewCell")
        resultView.resultsCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "resultsHeader")
    }
}

// MARK: UICollectionViewDataSource
extension ResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            var view = UICollectionReusableView()
            
            if collectionView == resultView.resultsCollectionView {
                view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "resultsHeader", for: indexPath)
                view.addSubview(resultView.headerStackView)
                resultView.headerStackView.activateEqualToSuperviewConstraints(topOffset: 8, bottomOffset: -12)
            } else if collectionView == resultView.categoriesCollectionView {
                view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoriesHeader", for: indexPath)
                let label = UILabel()
                label.textColor = .black
                label.numberOfLines = 1
                label.font = UIFont.systemFont(ofSize: 12)
                label.text = "Related"
                view.addSubview(label)
                label.activateEqualToSuperviewConstraints(leadingOffset: 16)
            }
            
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == resultView.resultsCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageViewCell", for: indexPath)
            let imageView = UIImageView(image: UIImage(named: "ImagePlaceholder"))
            imageView.contentMode = .scaleAspectFit
            cell.backgroundColor = .imagePlaceholderBackground
            cell.addSubview(imageView)
            imageView.activateEqualToSuperviewConstraints()
        } else if collectionView == resultView.categoriesCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "label", for: indexPath)
            let label = UILabel()
            label.backgroundColor = .white
            label.textColor = .black
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 12)
            label.text = testArray[indexPath.row]
            cell.addSubview(label)
            label.activateEqualToSuperviewConstraints()
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ResultViewController: UICollectionViewDelegate {
}
