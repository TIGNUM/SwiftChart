//
//  ToolsCollectionsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsInteractor {

    // MARK: - Properties

    private let worker: ToolsCollectionsWorker
    private let presenter: ToolsCollectionsPresenterInterface
    private let router: ToolsCollectionsRouterInterface

    // MARK: - Init

    init(worker: ToolsCollectionsWorker,
         presenter: ToolsCollectionsPresenterInterface,
         router: ToolsCollectionsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - ToolsInteractorInterface

extension ToolsCollectionsInteractor: ToolsCollectionsInteractorInterface {
    var headerTitle: String {
        return worker.headerTitle
    }

    var tools: [Tool.Item] {
        return worker.tools
    }

    var videoTools: [Tool.Item] {
        return worker.videoTools
    }

    var rowCount: Int {
        return worker.tools.count
    }

    func presentToolsItems(selectedToolID: Int?) {
        return router.presentToolsItems(selectedToolID: selectedToolID)
    }
}
