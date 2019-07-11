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

    private let viewController: MyLibraryCategoryListViewController

    // MARK: - Init

    init(viewController: MyLibraryCategoryListViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyLibraryCategoryListRouterInterface

extension MyLibraryCategoryListRouter: MyLibraryCategoryListRouterInterface {
    func presentLibraryItems(for type: MyLibraryCategoryType) {
        var storageType: UserStorageType
        switch type {
        case .ALL:
            storageType = .UNKOWN
        case .BOOKMARKS:
            storageType = .BOOKMARK
        case .DOWNLOADS:
            storageType = .DOWNLOAD
        case .LINKS:
            storageType = .EXTERNAL_LINK
        case .NOTES:
            storageType = .NOTE
        }

        guard let controller = R.storyboard.myLibraryUserStorage().instantiateInitialViewController() as? MyLibraryUserStorageViewController else {
            assertionFailure()
            return
        }
        let configurator = MyLibraryUserStorageConfigurator.make()
        configurator(controller, storageType)
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
}
