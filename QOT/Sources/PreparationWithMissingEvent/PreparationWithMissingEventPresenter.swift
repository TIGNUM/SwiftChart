//
//  PreparationWithMissingEventPresenter.swift
//  QOT
//
//  Created by Sanggeon Park on 18.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PreparationWithMissingEventPresenter {

    // MARK: - Properties

    private weak var viewController: PreparationWithMissingEventViewControllerInterface?

    // MARK: - Init

    init(viewController: PreparationWithMissingEventViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PreparationWithMissingEventInterface

extension PreparationWithMissingEventPresenter: PreparationWithMissingEventPresenterInterface {
    func reloadEvents() {
        viewController?.reloadEvents()
    }

    func update(title: String, text: String, removeButtonTitle: String, keepButtonTitle: String) {
        viewController?.update(title: title,
                               text: text,
                               removeButtonTitle: removeButtonTitle,
                               keepButtonTitle: keepButtonTitle)
    }
}
