//
//  SettingsBubblesInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsBubblesInteractor {

    let worker: SettingsBubblesWorker
    let router: SettingsBubblesRouterInterface
    let presenter: SettingsBubblesPresenterInterface

    init(worker: SettingsBubblesWorker,
         router: SettingsBubblesRouterInterface,
         presenter: SettingsBubblesPresenterInterface) {
        self.worker = worker
        self.router = router
        self.presenter = presenter
    }
}

// MARK: - SettingsBubblesInteractor Interface

extension SettingsBubblesInteractor: SettingsBubblesInteractorInterface {

    func handleSelection(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem) {
        router.handleSelection(bubbleTapped: bubbleTapped)
    }
}
