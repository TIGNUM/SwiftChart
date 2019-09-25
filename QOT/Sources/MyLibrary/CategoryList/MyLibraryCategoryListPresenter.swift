//
//  MyLibraryCategoryListPresenter.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryCategoryListPresenter {

    // MARK: - Properties

    private weak var viewController: MyLibraryCategoryListViewControllerInterface?

    // MARK: - Init

    init(viewController: MyLibraryCategoryListViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyLibraryCategoryListInterface

extension MyLibraryCategoryListPresenter: MyLibraryCategoryListPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func presentStorages() {
        viewController?.update()
    }
}
