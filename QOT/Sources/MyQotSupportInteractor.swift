//
//  MyQotSupportInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportInteractor {

    // MARK: - Properties

    private let worker: MyQotSupportWorker
    private let presenter: MyQotSupportPresenterInterface
    private let router: MyQotSupportRouterInterface

    // MARK: - Init

    init(worker: MyQotSupportWorker,
         presenter: MyQotSupportPresenterInterface,
         router: MyQotSupportRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    func viewDidLoad() {
        presenter.setupView()
    }
}

extension MyQotSupportInteractor: MyQotSupportInteractorInterface {
    func itemCount() -> Int {
        return worker.itemCount()
    }

    func item(at indexPath: IndexPath) -> MyQotSupportModel.MyQotSupportModelItem? {
        return worker.item(at: indexPath)
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        return worker.trackingKeys(at: indexPath)
    }

    func title(at indexPath: IndexPath) -> String {
        return worker.title(at: indexPath)
    }

    func subtitle(at indexPath: IndexPath) -> String {
        return worker.subtitle(at: indexPath)
    }

    func contentCollection(_ item: MyQotSupportModel.MyQotSupportModelItem) -> ContentCollection? {
        return worker.contentCollection(item)
    }

    func handleSelection(for indexPath: IndexPath) {
        guard let item = worker.item(at: indexPath) else { return }
        router.handleSelection(for: item, email: worker.email)
    }

    var supportText: String {
        return worker.supportText
    }
}
