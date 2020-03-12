//
//  ResultsPrepareInterface.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol ResultsPrepareViewControllerInterface: class {
    func setupView()
    func updateView(items: [ResultsPrepare.Items])
}

protocol ResultsPreparePresenterInterface {
    func setupView()
    func createListItems(preparation: QDMUserPreparation?)
}

protocol ResultsPrepareInteractorInterface: Interactor {
    var sectionCount: Int { get }
    var rowCount: Int { get }

    func item(at row: Int)
}

protocol ResultsPrepareRouterInterface {
    func dismiss()
}
