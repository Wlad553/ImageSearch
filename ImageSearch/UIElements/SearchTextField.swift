//
//  SearchTextField.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 15/06/2023.
//

import UIKit

final class SearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        super.clearButtonRect(forBounds: bounds)
        return CGRect(x: frame.width - 34, y: frame.height / 2 - 12, width: 24, height: 24)
    }
    
    private func setUp() {
        textColor = UIColor.black
        backgroundColor = UIColor.searchTextFieldBackground
        placeholder = "Search images, vectors and more"
        
        let magnifyingGlassImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        magnifyingGlassImageView.tintColor = .magnifyingGlass
        magnifyingGlassImageView.frame = CGRect(x: 10, y: -8, width: 18, height: 16)
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: frame.size.height))
        leftView?.addSubview(magnifyingGlassImageView)
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
        rightViewMode = .unlessEditing
        layer.cornerRadius = 5
        borderStyle = .none
        autocorrectionType = .no
        autocapitalizationType = .none
        clearButtonMode = .whileEditing
        
        returnKeyType = .search
        enablesReturnKeyAutomatically = true
    }
}
