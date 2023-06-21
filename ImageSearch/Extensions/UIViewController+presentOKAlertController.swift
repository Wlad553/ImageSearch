//
//  UIViewController+presentOKAlertController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 20/06/2023.
//

import UIKit

extension UIViewController {
    func presentOKAlertController(withTitle title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
