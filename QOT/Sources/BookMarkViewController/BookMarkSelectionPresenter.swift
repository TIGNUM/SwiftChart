//
//  BookMarkSelectionPresenter.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BookMarkSelectionPresenter {

    // MARK: - Properties

    private weak var viewController: BookMarkSelectionViewControllerInterface?

    // MARK: - Init

    init(viewController: BookMarkSelectionViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - BookMarkSelectionPresenterInterface

extension BookMarkSelectionPresenter: BookMarkSelectionPresenterInterface {
    func loadData() {
        viewController?.loadData()
    }
}
