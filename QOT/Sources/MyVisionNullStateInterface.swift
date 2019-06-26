//
//  MyToBeVisionNullStateInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyVisionNullStateViewControllerInterface: class {
    func setupView()
}

protocol MyVisionNullStatePresenterInterface {
    func setupView()
}

protocol MyVisionNullStateInteractorInterface: Interactor {
    func openToBeVisionGenerator()
    func openToBeVisionEditController()
    var headlinePlaceholder: String? { get }
    var messagePlaceholder: String? { get }
}

protocol MyVisionNullStateRouterInterface {
    func openToBeVisionGenerator()
    func openToBeVisionEditController()
}
