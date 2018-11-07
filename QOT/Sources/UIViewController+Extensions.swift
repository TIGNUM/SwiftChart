//
//  UIViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 05.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UIViewController {

    func setCustomBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.ic_back(),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToPreviousViewController))
    }

    @objc func backToPreviousViewController() {
        if let previousVC = navigationController?.viewControllers.dropLast().last {
            navigationController?.popToViewController(previousVC, animated: true)
        }
    }
}
