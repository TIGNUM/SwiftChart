//
//  MySprintsListInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MySprintsListViewControllerInterface: class {
    func update()
    func reloadData()
}

protocol MySprintsListPresenterInterface {
    func present()
    func presentData()
}

protocol MySprintsListInteractorInterface: Interactor {
    var title: String { get }
    var viewModel: MySprintsListViewModel { get }

    func didTapEdit()
    func handleSelectedItem(at indexPath: IndexPath) -> Bool
    func moveItem(at source: IndexPath, to destination: IndexPath)
}

protocol MySprintsListRouterInterface {
    func presentSprint(_ sprint: QDMSprint)
}
