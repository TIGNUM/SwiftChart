//
//  SettingsBubblesPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsBubblesPresenter {

    private weak var viewController: SettingsBubblesViewControllerInterface?

    init(viewController: SettingsBubblesViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SettingsBubblesPresenter Interface

extension SettingsBubblesPresenter: SettingsBubblesPresenterInterface {

    func load(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem) {
        viewController?.load(bubbleTapped: bubbleTapped)
    }
}
