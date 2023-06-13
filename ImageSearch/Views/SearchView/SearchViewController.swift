//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 11/06/2023.
//

import UIKit

class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    let searchView = SearchView()
    
    override func loadView() {
        super.loadView()
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
