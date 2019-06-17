//
//  ToolsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsInteractor {

    // MARK: - Properties

    private let worker: ToolsWorker
    private let presenter: ToolsPresenterInterface
    private let router: ToolsRouterInterface

    // MARK: - Init

    init(worker: ToolsWorker,
         presenter: ToolsPresenterInterface,
         router: ToolsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.present(for: worker.toolsSections())
        presenter.setupView()
    }
}

// MARK: - ToolsInteractorInterface

extension ToolsInteractor: ToolsInteractorInterface {

    func tools() -> [ToolItem] {
        return worker.tools
    }

    func presentToolsCollections(selectedToolID: Int?) {
        router.presentToolsCollections(selectedToolID: selectedToolID)
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        return worker.trackingKeys(at: indexPath)
    }
}
