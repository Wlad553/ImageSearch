//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import UIKit

final class SearchViewController: UIViewController {
    let viewModel: SearchViewViewModelType
    let searchView = SearchView()
    
    init(viewModel: SearchViewViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.searchTextField.delegate = self
        searchView.searchButton.addTarget(self, action: #selector(didPressSearchButton), for: .touchUpInside)
        addNotificationCenterObservers()
    }
    
    @objc func didPressSearchButton() {
        guard let searchText = searchView.searchTextField.text else { return }
        viewModel.didPressSearchButton(searchText: searchText)
    }
}

// MARK: UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return false }
        let newText = NSString(string: textFieldText).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            searchView.disableSearchButton()
        } else {
            searchView.enableSearchButton()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressSearchButton()
        return true
    }
}

// MARK: NotificationCenter
extension SearchViewController {
    private func addNotificationCenterObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotificationTriggered(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotificationTriggered(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardNotificationTriggered(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              searchView.searchTextField.isFirstResponder
        else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            searchView.moveViewUp(keyboardFrame: keyboardFrame)
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            searchView.moveViewToOriginalPosition()
        }
    }
}
