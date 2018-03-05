//
//  SharePresenter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnersPresenter: PartnersPresenterInterface {

    private weak var viewController: PartnersViewControllerInterface?

    init(viewController: PartnersViewControllerInterface) {
        self.viewController = viewController
    }

    func setup(partners: [Partners.Partner]) {
        viewController?.setup(partners: partners)
    }

    func reload(partner: Partners.Partner) {
        viewController?.reload(partner: partner)
    }
}
