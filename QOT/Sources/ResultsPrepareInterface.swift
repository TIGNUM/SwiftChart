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
    func updateView(items: [Int: ResultsPrepare.Sections])
}

protocol ResultsPreparePresenterInterface {
    func setupView()
    func createListItems(preparation: QDMUserPreparation?)
}

protocol ResultsPrepareInteractorInterface: Interactor {
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
}

protocol ResultsPrepareRouterInterface {
    func dismiss()
}
