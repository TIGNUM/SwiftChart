//
//  WhatsHotLatestInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import qot_dal
import UIKit

final class WhatsHotLatestInteractor {

    // MARK: - Properties

    private let worker: WhatsHotLatestWorker
    private let presenter: WhatsHotLatestPresenterInterface
    private let router: WhatsHotLatestRouterInterface

    // MARK: - Init

    init(worker: WhatsHotLatestWorker,
         presenter: WhatsHotLatestPresenterInterface,
         router: WhatsHotLatestRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
    }
}

// MARK: - WhatsHotLatestInteractorInterface

extension WhatsHotLatestInteractor: WhatsHotLatestInteractorInterface {
    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void)) {
        worker.latestWhatsHotCollectionID(completion: completion)
    }

    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void)) {
        worker.latestWhatsHotContent(completion: completion)
    }
    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void)) {
        worker.getContentCollection(completion: completion)
    }

    func presentWhatsHotArticle(selectedID: Int) {
        router.presentWhatsHotArticle(selectedID: selectedID)
    }
}
