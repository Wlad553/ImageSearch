//
//  SearchBarView.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 26/06/2023.
//

import UIKit
import SnapKit

final class SearchBarView: UIView {
    private let stackView = UIStackView()
    let logoLabel = UILabel()
    let searchTextField = SearchTextField()
    let optionsButton = UIButton()
    let viewModel: SearchBarViewViewModelType
    
    init(viewModel: SearchBarViewViewModelType) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpStackView()
        setUpLogoLabel()
        setUpSearchTextField()
        setUpOptionsButton()
        addConstraints()
        createContextMenu()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let superviewSafe = superview else { return }
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.border.cgColor
        bottomLine.frame = CGRect(x: 0, y: 59,
                                  width: superviewSafe.frame.width, height: 1)
        layer.addSublayer(bottomLine)
    }
    
    // MARK: Subviews setup
    private func setUpStackView() {
        let innerStackView = UIStackView(arrangedSubviews: [searchTextField, optionsButton])
        innerStackView.axis = .horizontal
        innerStackView.spacing = 8
        innerStackView.alignment = .fill
        innerStackView.distribution = .equalSpacing
        
        addSubview(stackView)
        stackView.addArrangedSubview(logoLabel)
        stackView.addArrangedSubview(innerStackView)
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .equalCentering
    }
    
    private func setUpLogoLabel() {
        logoLabel.text = "P"
        logoLabel.textAlignment = .center
        logoLabel.font = UIFont(name: Fonts.Pattaya.regular.rawValue, size: 32)
        logoLabel.textColor = .white
        logoLabel.layer.backgroundColor = UIColor.searchButtonBackground.cgColor
        logoLabel.layer.cornerRadius = 5
    }
    
    private func setUpSearchTextField() {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.border.cgColor
    }
    
    private func setUpOptionsButton() {
        optionsButton.layer.borderColor = UIColor.border.cgColor
        optionsButton.layer.borderWidth = 1
        optionsButton.layer.cornerRadius = 5
        optionsButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        optionsButton.tintColor = .optionsButton
        optionsButton.showsMenuAsPrimaryAction = true
        
        optionsButton.imageView?.snp.makeConstraints { make in
            make.height.width.equalTo(32)
        }
    }
    
    private func createContextMenu() {
        let popularFilter = UIAction(title: "Popular",
                                     state: viewModel.selectedFilter == .popular ? .on : .off) { action in
            if self.viewModel.selectedFilter == .latest {
                self.viewModel.selectedFilter = .popular
            }
            self.createContextMenu()
        }
        
        let latestFilter = UIAction(title: "Latest",
                                    state: viewModel.selectedFilter == .latest ? .on : .off) { action in
            if self.viewModel.selectedFilter == .popular {
                self.viewModel.selectedFilter = .latest
            }
            self.createContextMenu()
        }
        
        optionsButton.menu = UIMenu(children: [popularFilter, latestFilter])
    }
    
    // MARK: Subviews constraints
    private func addConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview().offset(-12)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.height.width.equalTo(48)
        }

        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        optionsButton.snp.makeConstraints { make in
            make.height.width.equalTo(48)
        }
    }
}
