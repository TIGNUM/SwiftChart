//
//  SyncedCalendarsRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SyncedCalendarsRouter {

    // MARK: - Properties
    private weak var viewController: SyncedCalendarsViewController?

    // MARK: - Init
    init(_ viewController: SyncedCalendarsViewController?) {
        self.viewController = viewController
    }
}

extension SyncedCalendarsRouter: SyncedCalendarsRouterInterface {
    func dismiss(completion: (() -> Void)?) {
        viewController?.dismiss(animated: true, completion: completion)
    }
}
