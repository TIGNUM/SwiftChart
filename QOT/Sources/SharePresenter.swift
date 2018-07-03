//
//  SharePresenter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SharePresenter {

    private weak var viewController: ShareViewControllerInterface?

    init(viewController: ShareViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SharePresenterInterface

extension SharePresenter: SharePresenterInterface {

    func setup() {
        viewController?.setup()
        viewController?.setPartnerProfileImage()
    }

    func setLoading(loading: Bool) {
        viewController?.setLoading(loading: loading)
    }
}
