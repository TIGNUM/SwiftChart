//
//  BookMarkSelectionRouter.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BookMarkSelectionRouter {

    // MARK: - Properties

    private let viewController: BookMarkSelectionViewController

    // MARK: - Init

    init(viewController: BookMarkSelectionViewController) {
        self.viewController = viewController
    }
}

// MARK: - BookMarkSelectionRouterInterface

extension BookMarkSelectionRouter: BookMarkSelectionRouterInterface {

}
