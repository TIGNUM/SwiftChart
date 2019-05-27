//
//  ToolsItemsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsItemsInteractor {

    // MARK: - Properties

    private let worker: ToolsItemsWorker
    private let presenter: ToolsItemsPresenterInterface

    // MARK: - Init

    init(worker: ToolsItemsWorker,
         presenter: ToolsItemsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - ToolsInteractorInterface

extension ToolsItemsInteractor: ToolsItemsInteractorInterface {

    var headerTitle: String {
        return worker.headerTitle
    }

    var headerSubtitle: String {
        return worker.headerSubtitle
    }

    var tools: [Tool.Item] {
        return worker.tools
    }

    var rowCount: Int {
        return worker.tools.count
    }
}
