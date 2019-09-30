//
//  MyLibraryCategoryListRouter.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryCategoryListRouter {

    // MARK: - Properties

    private weak var viewController: MyLibraryCategoryListViewController?

    // MARK: - Init

    init(viewController: MyLibraryCategoryListViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyLibraryCategoryListRouterInterface

extension MyLibraryCategoryListRouter: MyLibraryCategoryListRouterInterface {
    func presentLibraryItems(for item: MyLibraryCategoryListModel) {
        guard let controller = R.storyboard.myLibraryUserStorage().instantiateInitialViewController() as? MyLibraryUserStorageViewController else {
            assertionFailure()
            return
        }
        let configurator = MyLibraryUserStorageConfigurator.make()
        configurator(controller, item)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
