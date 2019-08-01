//
//  MySprintDetailsPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintDetailsPresenter {

    // MARK: - Properties

    private weak var viewController: MySprintDetailsViewControllerInterface?

    // MARK: - Init

    init(viewController: MySprintDetailsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MySprintDetailsInterface

extension MySprintDetailsPresenter: MySprintDetailsPresenterInterface {
    func present() {
        viewController?.update()
    }
    func trackSprintPause() {
        viewController?.trackSprintPause()
    }

    func trackSprintContinue() {
        viewController?.trackSprintContinue()
    }

    func trackSprintStart() {
        viewController?.trackSprintStart()
    }
}
