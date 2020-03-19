//
//  DTPrepareStartConfigurator.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class DTPrepareStartConfigurator {
    static func make() -> (DTPrepareStartViewController) -> Void {
        return { (viewController) in
            let presenter = DTPrepareStartPresenter(viewController: viewController)
            let interactor = DTPrepareStartInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
