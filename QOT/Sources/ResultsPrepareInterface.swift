//
//  ResultsPrepareInterface.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol ResultsPrepareViewControllerInterface: class {
    func setupView()
}

protocol ResultsPreparePresenterInterface {
    func setupView()
}

protocol ResultsPrepareInteractorInterface: Interactor {
    var sectionCount: Int { get }
    var rowCount: Int { get }

    func item(at row: Int)
}

protocol ResultsPrepareRouterInterface {
    func dismiss()
}
