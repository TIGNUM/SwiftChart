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
    func setup(for myDataSelectionSection: MyDataSelectionModel,
               myDataSelectionHeaderTitle: String,
               myDataSelectionHeaderSubtitle: String)
}

protocol MyDataSelectionPresenterInterface {
    func setupView()
    func present(for: MyDataSelectionModel,
                 myDataSelectionHeaderTitle: String,
                 myDataSelectionHeaderSubtitle: String)
}

protocol MyDataSelectionInteractorInterface: Interactor {
    func saveMyDataSelections(_ selections: [MyDataSelectionModel.SelectionItem])
}

protocol MyDataSelectionRouterInterface {
    func dismiss()
}

protocol MyDataSelectionWorkerInterface {
    func myDataSelectionSections() -> MyDataSelectionModel
    func saveMyDataSelections(_ selections: [MyDataParameter])
}
