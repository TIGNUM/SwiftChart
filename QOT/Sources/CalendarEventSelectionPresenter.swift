//
//  CalendarEventSelectionPresenter.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CalendarEventSelectionPresenter {

    // MARK: - Properties
    private weak var viewController: CalendarEventSelectionViewControllerInterface?

    // MARK: - Init
    init(viewController: CalendarEventSelectionViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - CalendarEventSelectionInterface
extension CalendarEventSelectionPresenter: CalendarEventSelectionPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func showLoadingDots() {
        viewController?.showLoadingDots()
    }

    func hideLoadingDots() {
        viewController?.hideLoadingDots()
    }
}
