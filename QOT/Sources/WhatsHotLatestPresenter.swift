//
//  WhatsHotLatestPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotLatestPresenter {

    // MARK: - Properties

    private weak var viewController: WhatsHotLatestViewControllerInterface?

    // MARK: - Init

    init(viewController: WhatsHotLatestViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - WhatsHotLatestInterface

extension WhatsHotLatestPresenter: WhatsHotLatestPresenterInterface {
}
