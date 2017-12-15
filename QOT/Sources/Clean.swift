//
//  Clean.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

typealias Configurator<ViewController> = (ViewController) -> Void

/**
 Base protocol that `Interactors` should inherit from.
 */
protocol Interactor {
    func viewDidLoad()
}

extension Interactor {

    func viewDidLoad() {
        assertionFailure("\(#function) not implemented")
    }
}

/**
 Mirrors functions of `UIViewController`.
 */
protocol UIViewControllerInterface {

    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: UIViewControllerInterface {}
