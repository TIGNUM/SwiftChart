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
    func update()
}

protocol MyLibraryCategoryListPresenterInterface {
    func presentLoadingStatus()
    func presentEmptyStatus()
    func presentStorages()
}

protocol MyLibraryCategoryListInteractorInterface: Interactor {
    var categoryItems: [MyLibraryCategoryListModel] { get }
    func handleSelectedItem(at index: Int)
}

protocol MyLibraryCategoryListRouterInterface {
    func presentLibraryItems(for type: MyLibraryCategoryType)
}
