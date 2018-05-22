//
//  PartnerEditPresenter.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditPresenter {

    // MARK: - Properties

    private let viewController: PartnerEditViewControllerInterface

    // MARK: - Init

    init(viewController: PartnerEditViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PartnerEditInterface

extension PartnerEditPresenter: PartnerEditPresenterInterface {

    func reload(partner: Partners.Partner) {
        viewController.reload(partner: partner)
    }

    func setupView(partner: Partners.Partner) {
        viewController.setupView(partner: partner)
    }
}
