//
//  SearchConfigurator.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SearchConfigurator {

    static func make(delegate: CoachCollectionViewControllerDelegate?) -> (SearchViewController) -> Void {
        return { (searchViewController) in
            let router = SearchRouter(searchViewController: searchViewController)
            let worker = SearchWorker()
            let presenter = SearchPresenter(viewController: searchViewController)
            let interactor = SearchInteractor(worker: worker, router: router, presenter: presenter)
            searchViewController.interactor = interactor
            searchViewController.delegate = delegate
        }
    }
}
