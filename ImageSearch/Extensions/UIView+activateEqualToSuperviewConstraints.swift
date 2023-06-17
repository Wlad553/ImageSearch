//
//  UIView+activateEqualToSuperviewConstraints.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 16/06/2023.
//

import UIKit
import SnapKit

// MARK: Constraints
extension UIView {
    func activateEqualToSuperviewConstraints(topOffset: Double = 0,
                                             bottomOffset: Double = 0,
                                             leadingOffset: Double = 0,
                                             trailingOffset: Double = 0) {
        guard superview != nil else { return }
        snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.bottom.equalToSuperview().offset(bottomOffset)
            make.leading.equalToSuperview().offset(leadingOffset)
            make.trailing.equalToSuperview().offset(trailingOffset)
        }
    }
}
