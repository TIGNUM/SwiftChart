//
//  MyQotSupportDetailsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportDetailsInteractor {

    // MARK: - Properties

    private let worker: MyQotSupportDetailsWorker
    private let presenter: MyQotSupportDetailsPresenterInterface
    private let router: MyQotSupportDetailsRouterInterface

    // MARK: - Init

    init(worker: MyQotSupportDetailsWorker,
         presenter: MyQotSupportDetailsPresenterInterface,
         router: MyQotSupportDetailsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        worker.fetchItems {[weak self] in
            self?.presenter.setupView()
        }
    }
}

extension MyQotSupportDetailsInteractor: MyQotSupportDetailsInteractorInterface {
    var category: ContentCategory {
        return worker.category
    }

    var headerText: String {
        return worker.headerText
    }

    var itemCount: Int {
        return worker.itemCount
    }

    func item(at indexPath: IndexPath) -> QDMContentCollection {
        return worker.item(at: indexPath)
    }

    func trackingID(at indexPath: IndexPath) -> Int {
        return worker.trackingID(at: indexPath)
    }

    func title(at indexPath: IndexPath) -> String {
        return worker.title(at: indexPath)
    }

    func presentContentItemSettings(contentID: Int) {
        router.presentContentItemSettings(contentID: contentID)
    }
}
