//
//  CropImageViewController.swift
//  ImageSearch
//
//  Created by Vladyslav Petrenko on 13/07/2023.
//

import UIKit
import CropViewController

final class CropImageViewController: TOCropViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonTitle = "Share"
        showActivitySheetOnDone = true
    }
}
