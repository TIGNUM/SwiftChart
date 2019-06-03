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
        let backButton = UIBarButtonItem(image: R.image.arrowBack(),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToPreviousViewController))
        backButton.tintColor = .accent
        navigationItem.leftBarButtonItem = backButton
    }

    func setCustomBackButtonSearch() {
        let backButtonItem = UIBarButtonItem(image: R.image.ic_cancel(),
                                             style: .plain,
                                             target: self,
                                             action: #selector(backToPreviousViewController))
        backButtonItem.tintColor = .accent
        navigationItem.rightBarButtonItem = backButtonItem
    }

    @objc func backToPreviousViewController() {
        if let previousVC = navigationController?.viewControllers.dropLast().last {
            navigationController?.popToViewController(previousVC, animated: true)
        }
    }

    func attachToEdge(_ subview: UIView) {
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        subview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
