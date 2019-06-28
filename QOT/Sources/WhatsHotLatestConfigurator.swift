//
//  WhatsHotLatestConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class WhatsHotLatestConfigurator {

    static func make(viewController: WhatsHotLatestViewController?) {
        guard let viewController = viewController else { return }
        let router = WhatsHotLatestRouter(viewController: viewController)
        let worker = WhatsHotLatestWorker()
        let presenter = WhatsHotLatestPresenter(viewController: viewController)
        let interactor = WhatsHotLatestInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
