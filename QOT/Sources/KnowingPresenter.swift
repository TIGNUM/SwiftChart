//
//  KnowingPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class KnowingPresenter {

    // MARK: - Properties

    private weak var viewController: KnowingViewControllerInterface?

    // MARK: - Init

    init(viewController: KnowingViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - KnowingInterface

extension KnowingPresenter: KnowingPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reload() {
        viewController?.reload()
    }

    func scrollToSection(_ section: Knowing.Section) {
        viewController?.scrollToSection(section.rawValue)
    }
}
