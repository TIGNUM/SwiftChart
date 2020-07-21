//
//  BookMarkSelectionConfigurator.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class BookMarkSelectConfigurator {
    static func make(storages: [QDMUserStorage]?) -> (BookMarkSelectionViewController) -> Void {
        return { (viewController) in
            let router = BookMarkSelectionRouter(viewController: viewController)
            let worker = BookMarkSelectionWorker()
            let presenter = BookMarkSelectionPresenter(viewController: viewController)
            let interactor = BookMarkSelectionInteractor(storages: storages ?? [],
                                                      worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
