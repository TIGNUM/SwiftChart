//
//  SigningInfoConfigurator.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SigningInfoConfigurator {
    static func make() -> (SigningInfoViewController) -> Void {
        return { (viewController) in
            let router = SigningInfoRouter(viewController: viewController)
            let worker = SigningInfoWorker(model: SigningInfoModel())
            let presenter = SigningInfoPresenter(viewController: viewController)
            let interactor = SigningInfoInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
