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
    }
}
