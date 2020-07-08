//
//  halloConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class halloConfigurator {
    static func make() -> (halloViewController) -> Void {
        return { (viewController) in
            let presenter = halloPresenter(viewController: viewController)
            let interactor = halloInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
