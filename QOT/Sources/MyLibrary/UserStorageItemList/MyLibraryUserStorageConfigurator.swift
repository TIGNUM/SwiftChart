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

    static func make() -> (MyLibraryUserStorageViewController, MyLibraryCategoryListModel) -> Void {
        return { (viewController, item) in
            let router = MyLibraryUserStorageRouter(viewController: viewController)
            let worker = MyLibraryUserStorageWorker(item: item)
            let presenter = MyLibraryUserStoragePresenter(viewController: viewController)
            let interactor = MyLibraryUserStorageInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
