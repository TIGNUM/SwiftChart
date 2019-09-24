//
//  MyLibraryCategoryListInterface.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyLibraryCategoryListViewControllerInterface: class {
    func setupView()
    func update()
}

protocol MyLibraryCategoryListPresenterInterface {
    func setupView()
    func presentStorages()
}

protocol MyLibraryCategoryListInteractorInterface: Interactor {
    var titleText: String { get }
    var categoryItems: [MyLibraryCategoryListModel] { get }
    func handleSelectedItem(at index: Int)
}

protocol MyLibraryCategoryListRouterInterface {
    func presentLibraryItems(for type: MyLibraryCategoryType)
}
