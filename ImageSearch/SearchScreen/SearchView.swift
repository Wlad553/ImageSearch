//
//  SearchView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import UIKit
import SnapKit

final class SearchView: UIView {
    private let searchStackView = UIStackView()
    let imageView = UIImageView(image: UIImage(named: "Alberta"))
    let welcomeLabel = UILabel()
    let searchTextField = SearchTextField()
    let searchButton = BlueButton(title: "Search", image: UIImage(systemName: "magnifyingglass"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
        setUpWelcomeLabel()
        setUpSearchButton()
        setUpSearchStackView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
    
    // MARK: Subviews setup
    private func setUpImageView() {
        imageView.layer.opacity = 0.6
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
    }
    
    private func setUpWelcomeLabel() {
        addSubview(welcomeLabel)
        let attributedText = NSMutableAttributedString(string: "Zabierz swoich odbiorców na wizualną przygodę")
        attributedText.addAttribute(.baselineOffset, value: 8, range: NSRange(location: 0, length: attributedText.string.count))
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont(name: Fonts.OpenSans.extraBold.rawValue, size: 26)
        welcomeLabel.textColor = .welcomeLabel
        welcomeLabel.textAlignment = .center
        welcomeLabel.attributedText = attributedText
    }
    
    private func setUpSearchTextField() {
        searchTextField.textColor = UIColor.black
        searchTextField.backgroundColor = UIColor.searchTextFieldBackground
        searchTextField.placeholder = "Search images, vectors and more"
        
        let magnifyingGlassImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        magnifyingGlassImageView.tintColor = .magnifyingGlass
        magnifyingGlassImageView.frame = CGRect(x: 12, y: -8, width: 20, height: 16)
        
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: searchTextField.frame.size.height))
        searchTextField.leftView?.addSubview(magnifyingGlassImageView)
        searchTextField.leftViewMode = .always
        searchTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: searchTextField.frame.size.height))
        searchTextField.rightViewMode = .unlessEditing
        searchTextField.layer.cornerRadius = 5
        searchTextField.borderStyle = .none
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.clearButtonMode = .whileEditing
    }
    
    private func setUpSearchButton() {
        searchButton.isUserInteractionEnabled = false
        searchButton.titleLabel?.alpha = 0.6
        searchButton.imageView?.alpha = 0.6
        searchButton.imageView?.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.7, 0.7, 0.7),
                                                         CATransform3DMakeTranslation(-5, 0, 0))
    }
    
    private func setUpSearchStackView() {
        addSubview(searchStackView)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        searchStackView.axis = .vertical
        searchStackView.spacing = 30
        searchStackView.distribution = .equalSpacing
        searchStackView.alignment = .fill
    }
    
    // MARK: Subviews constraints
    private func addConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        searchStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(searchStackView.spacing)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(searchStackView.snp_topMargin).offset(-48)
        }
    }
}

// MARK: Animations
extension SearchView {
    // MARK: SearchButton
    func disableSearchButton() {
        searchButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.searchButton.titleLabel?.alpha = 0.6
            self.searchButton.imageView?.alpha = 0.6
        }
    }
    
    func enableSearchButton() {
        searchButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.searchButton.titleLabel?.alpha = 1
            self.searchButton.imageView?.alpha = 1
        }
    }
    
    // MARK: View
    func moveViewUp(keyboardFrame: CGRect) {
        UIView.animate(withDuration: 0.2) {
            self.welcomeLabel.alpha = 0
            self.searchStackView.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(self.searchStackView.spacing - keyboardFrame.height / 3)
            }
            self.layoutIfNeeded()
        }
    }
    
    func moveViewToOriginalPosition() {
        UIView.animate(withDuration: 0.2) {
            self.welcomeLabel.alpha = 1
            self.searchStackView.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(self.searchStackView.spacing)
            }
            self.layoutIfNeeded()
        }
    }
}
