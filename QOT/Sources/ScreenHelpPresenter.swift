//
//  ScreenHelpPresenter.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class ScreenHelpPresenter {
    private weak var viewController: ScreenHelpViewControllerInterface?

    init(viewController: ScreenHelpViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - ScreenHelpPresenterInterface

extension ScreenHelpPresenter: ScreenHelpPresenterInterface {
    func load(_ helpItem: ScreenHelp.Item?) {
        viewController?.updateHelpItem(helpItem)
    }
}
