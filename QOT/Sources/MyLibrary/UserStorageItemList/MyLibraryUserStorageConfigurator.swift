//
//  MyLibraryBookmarksConfigurator.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyLibraryUserStorageConfigurator {

    static func make(with team: QDMTeam?, _ category: String? = nil) -> (MyLibraryUserStorageViewController, MyLibraryCategoryListModel) -> Void {
        return { (viewController, item) in
            let router = MyLibraryUserStorageRouter(viewController: viewController)
            let worker = MyLibraryUserStorageWorker(item: item)
            let presenter = MyLibraryUserStoragePresenter(viewController: viewController)
            let interactor = MyLibraryUserStorageInteractor(team: team, category: category,
                                                            worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
