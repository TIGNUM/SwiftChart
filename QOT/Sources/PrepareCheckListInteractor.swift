//
//  PrepareCheckListInteractor.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareCheckListInteractor {

    // MARK: - Properties

    private let worker: PrepareCheckListWorker
    private let presenter: PrepareCheckListPresenterInterface
    private let router: PrepareCheckListRouterInterface

    // MARK: - Init

    init(worker: PrepareCheckListWorker,
        presenter: PrepareCheckListPresenterInterface,
        router: PrepareCheckListRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.registerTableViewCell(for: worker.type)
        presenter.setupView()
    }
}

// MARK: - PrepareCheckListInteractorInterface

extension PrepareCheckListInteractor: PrepareCheckListInteractorInterface {
    var type: PrepareCheckListType {
        return worker.type
    }

    var sectionCount: Int {
        return worker.sectionCount
    }

    func rowCount(in section: Int) -> Int {
        return worker.rowCount(in: section)
    }

    func item(at indexPath: IndexPath) -> PrepareCheckListItem? {
        return worker.item(at: indexPath)
    }

    func attributedText(title: String?, itemFormat: ContentItemFormat?) -> NSAttributedString? {
        return worker.attributedText(title: title, itemFormat: itemFormat)
    }

    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        return worker.rowHeight(at: indexPath)
    }

    func hasBottomSeperator(at indexPath: IndexPath) -> Bool {
        return worker.hasBottomSeperator(at: indexPath)
    }

    func hasListMark(at indexPath: IndexPath) -> Bool {
        return worker.hasListMark(at: indexPath)
    }

    func hasHeaderMark(at indexPath: IndexPath) -> Bool {
        return worker.hasHeaderMark(at: indexPath)
    }

    func presentRelatedArticle(readMoreID: Int) {
        router.presentRelatedArticle(readMoreID: readMoreID)
    }

    func didClickSaveAndContinue() {
        router.didClickSaveAndContinue()
    }

    func openEditStrategyView() {
        router.openEditStrategyView(services: worker.getServices,
                                    relatedStrategies: worker.getRelatedContent,
                                    selectedIDs: worker.getSelectedIDs)
    }
}
