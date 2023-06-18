//
//  BlueButton.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 15/06/2023.
//

import UIKit
import SnapKit

final class BlueButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp(title: nil, image: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, image: UIImage) {
        self.init(type: .system)
        setUp(title: title, image: image)
    }
    
    private func setUp(title: String?, image: UIImage?) {
        titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        
        setImage(image, for: .normal)
        tintColor = .white
        imageView?.contentMode = .scaleAspectFit
        
        titleLabel?.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        imageView?.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.7, 0.7, 0.7),
                                                         CATransform3DMakeTranslation(-5, 0, 0))

        backgroundColor = .searchButtonBackground
        layer.cornerRadius = 5
    }
}
