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
    func save()
    func dismiss()
    func didTapItem(index: Int)
}

protocol BookMarkSelectionRouterInterface {
    func dismiss(_ isChanged: Bool?)
}
