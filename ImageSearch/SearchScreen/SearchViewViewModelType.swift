//
//  SearchViewViewModelType.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 18/06/2023.
//

import Foundation
import XCoordinator

protocol SearchViewViewModelType: AnyObject {
    var networkManager: NetworkManagerProtocol { get }
    var router: UnownedRouter<AppRoute> { get }
    func didPressSearchButton(searchText: String)
}
