//
//  SubsriptionReminderPresenter.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SubsriptionReminderPresenter {

    // MARK: - Properties

    private weak var viewController: SubsriptionReminderViewControllerInterface?

    // MARK: - Init

    init(viewController: SubsriptionReminderViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SubsriptionReminderInterface

extension SubsriptionReminderPresenter: SubsriptionReminderPresenterInterface {
    func load() {

    }

    func setupView() {
        viewController?.setupView()
    }
}
