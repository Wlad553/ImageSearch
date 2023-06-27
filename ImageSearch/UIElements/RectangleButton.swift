//
//  RectangleButton.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 26/06/2023.
//

import UIKit

class RectangleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp(image: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage?) {
        self.init(type: .system)
        setUp(image: image)
    }
    
    private func setUp(image: UIImage?) {
        setImage(image, for: .normal)
        tintColor = .searchButtonBackground
        
        layer.backgroundColor = UIColor.border.cgColor
        layer.cornerRadius = 5
    }
}
