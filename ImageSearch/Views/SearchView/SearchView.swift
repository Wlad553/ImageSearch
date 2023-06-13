//
//  SearchView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import UIKit
import SnapKit

class SearchView: UIView {
    let imageView = UIImageView(image: UIImage(named: "Alberta"))
    let welcomeLabel = UILabel()
    let searchTextField = UITextField()
    let searchButton = UIButton(type: .system)
    let searchStackView = UIStackView()
    
    override init(frame: CGRect) {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { fatalError("No windowScene found") }
            super.init(frame: windowScene.screen.bounds)
        } else {
            super.init(frame: UIScreen.main.bounds)
        }
        setUpImageView()
        setUpTopLabel()
        setUpSearchTextField()
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
    
    private func setUpImageView() {
        imageView.layer.opacity = 0.6
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
    }
    
    private func setUpTopLabel() {
        addSubview(welcomeLabel)
        let attributedText = NSMutableAttributedString(string: "Zabierz swoich odbiorców na wizualną przygodę")
        attributedText.addAttribute(.baselineOffset, value: 8, range: NSRange(location: 0, length: attributedText.string.count))
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont(name: "OpenSans-ExtraBold", size: 26)
        welcomeLabel.textColor = .welcomeLabel
        welcomeLabel.textAlignment = .center
        welcomeLabel.attributedText = attributedText
    }
    
    private func setUpSearchTextField() {
        searchTextField.textColor = UIColor.black
        searchTextField.backgroundColor = UIColor.searchTextFieldBackground
        searchTextField.placeholder = "Search images, vectors and more"
        
        let magnifyingGlassImageView = UIImageView(image: UIImage(named: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        magnifyingGlassImageView.tintColor = .darkGray
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
        searchButton.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        
        searchButton.setImage(UIImage(named: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        searchButton.titleLabel?.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        searchButton.imageView?.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        searchButton.imageView?.layer.transform = CATransform3DMakeScale(0.65, 0.65, 0.65)

        
        searchButton.backgroundColor = .searchButtonBackground
        searchButton.layer.cornerRadius = 5
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
            make.centerY.equalToSuperview().offset((searchStackView.spacing + searchTextField.frame.height) / 2)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(searchStackView.snp_topMargin).offset(-48)
        }
    }
}
