//
//  MyDataSelectionInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyDataSelectionViewControllerInterface: class {
    func setupView()
}

protocol MyDataSelectionPresenterInterface {
    func setupView()
}

protocol MyDataSelectionInteractorInterface: Interactor {}

protocol MyDataSelectionRouterInterface {
    func dismiss()
}
