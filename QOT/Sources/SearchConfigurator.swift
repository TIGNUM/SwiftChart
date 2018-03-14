//
//  SearchConfigurator.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SearchConfigurator: AppStateAccess {

    static func make() -> (SearchViewController) -> Void {
        return { (searchViewController) in
            let router = SearchRouter(searchViewController: searchViewController)
            let worker = SearchWorker(services: appState.services)
            let presenter = SearchPresenter(viewController: searchViewController)
            let interactor = SearchInteractor(worker: worker, router: router, presenter: presenter)
            searchViewController.interactor = interactor
        }
    }
}
