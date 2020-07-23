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
    private let completion: ((Bool) -> Void)

    // MARK: - Init

    init(viewController: BookMarkSelectionViewController, _ completion: @escaping (Bool) -> Void) {
        self.viewController = viewController
        self.completion = completion
    }
}

// MARK: - BookMarkSelectionRouterInterface

extension BookMarkSelectionRouter: BookMarkSelectionRouterInterface {
    func dismiss(_ isChanged: Bool?) {
        viewController.dismiss(animated: true) {
            self.completion(isChanged ?? false)
        }
    }
}
