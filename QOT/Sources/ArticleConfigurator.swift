//
//  ArticleConfigurator.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class ArticleConfigurator {
    static func configure(selectedID: Int, viewController: ArticleViewController) {
        let router = ArticleRouter(viewController: viewController)
        let worker = ArticleWorker(selectedID: selectedID)
        let presenter = ArticlePresenter(viewController: viewController)
        let interactor = ArticleInteractor(worker: worker, presenter: presenter, router: router)
        worker.interactor = interactor
        viewController.interactor = interactor
    }
}
