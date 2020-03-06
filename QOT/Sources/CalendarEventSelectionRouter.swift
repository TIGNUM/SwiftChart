//
//  CalendarEventSelectionRouter.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CalendarEventSelectionRouter {

    // MARK: - Properties
    private weak var viewController: CalendarEventSelectionViewController?

    // MARK: - Init
    init(viewController: CalendarEventSelectionViewController?) {
        self.viewController = viewController
    }
}

// MARK: - CalendarEventSelectionRouterInterface
extension CalendarEventSelectionRouter: CalendarEventSelectionRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
