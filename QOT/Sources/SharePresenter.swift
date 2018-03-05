//
//  SharePresenter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SharePresenter: SharePresenterInterface {

    private weak var viewController: ShareViewControllerInterface?

    init(viewController: ShareViewControllerInterface) {
        self.viewController = viewController
    }

    func setup(name: String) {
        viewController?.setHeader(R.string.localized.meSectorMyWhyPartnersShareHeader(name))
    }
}
