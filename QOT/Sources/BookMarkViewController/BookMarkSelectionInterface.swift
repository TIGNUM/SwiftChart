//
//  BookMarkSelectionInterface.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol BookMarkSelectionViewControllerInterface: UIViewController {
    func loadData()
}

protocol BookMarkSelectionPresenterInterface {
    func loadData()
}

protocol BookMarkSelectionInteractorInterface: Interactor {
    var viewModels: [BookMarkSelectionModel] { get set }
    var headerTitle: String { get }
    var myLibraryCellTitle: String { get }
    var myLibraryCellSubtitle: String { get }
    var memberCountTemplateString: String { get }
    var saveButtonTitle: String { get }

    func save()
    func dismiss()
    func didTapItem(index: Int)
}

protocol BookMarkSelectionRouterInterface {
    func dismiss(_ isChanged: Bool?)
}
