//
//  RegistrationNamesConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class RegistrationNamesConfigurator: AppStateAccess {

    static func make() -> (RegistrationNamesViewController, RegistrationDelegate) -> Void {
        return { (viewController, delegate) in
            let router = RegistrationNamesRouter(viewController: viewController)
            let worker = RegistrationNamesWorker()
            let presenter = RegistrationNamesPresenter(viewController: viewController)
            let interactor = RegistrationNamesInteractor(worker: worker,
                                                         presenter: presenter,
                                                         router: router,
                                                         delegate: delegate)
            viewController.interactor = interactor
        }
    }
}
