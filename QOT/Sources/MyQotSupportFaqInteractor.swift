//
//  MyQotSupportFaqInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportFaqInteractor {

    // MARK: - Properties

    private let worker: MyQotSupportFaqWorker
    private let presenter: MyQotSupportFaqPresenterInterface
    private let router: MyQotSupportFaqRouterInterface

    // MARK: - Init

    init(worker: MyQotSupportFaqWorker,
         presenter: MyQotSupportFaqPresenterInterface,
         router: MyQotSupportFaqRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView(with: worker.faqHeaderText)
    }
}

extension MyQotSupportFaqInteractor: MyQotSupportFaqInteractorInterface {

    var faqHeaderText: String {
        return worker.faqHeaderText
    }

    var itemCount: Int {
        return worker.itemCount
    }

    func item(at indexPath: IndexPath) -> ContentCollection {
        return worker.item(at: indexPath)
    }

    func trackingID(at indexPath: IndexPath) -> Int {
        return worker.trackingID(at: indexPath)
    }

    func title(at indexPath: IndexPath) -> String {
        return worker.title(at: indexPath)
    }

    func presentContentItemSettings(contentID: Int, pageName: PageName, pageTitle: String) {
        router.presentContentItemSettings(contentID: contentID,
                                          pageName: pageName,
                                          pageTitle: pageTitle)
    }
}
