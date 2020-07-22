//
//  BookMarkSelectionConfigurator.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class BookMarkSelectionConfigurator {
    static func make(contentId: Int,
                     contentType: UserStorageContentType)
        -> (BookMarkSelectionViewController, @escaping (Bool) -> Void) -> Void {
        return { (viewController, completion) in
            let router = BookMarkSelectionRouter(viewController: viewController, completion)
            let worker = BookMarkSelectionWorker()
            let presenter = BookMarkSelectionPresenter(viewController: viewController)
            let interactor = BookMarkSelectionInteractor(contentId: contentId, contentType: contentType,
                                                         worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
