//
//  ChoiceInteractor.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ChoiceInteractor {

    // MARK: - Properties
    private let worker: ChoiceWorker
    private let presenter: ChoicePresenterInterface
    private let router: ChoiceRouterInterface

    // MARK: - Init
    init(worker: ChoiceWorker,
        presenter: ChoicePresenterInterface,
        router: ChoiceRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - ChoiceInteractorInterface
extension ChoiceInteractor: ChoiceInteractorInterface {
    func generateItems() {
        worker.generateItems { [weak self] in
            self?.presenter.reloadTableView()
        }
    }

    var selected: [Choice] {
        return worker.selected
    }

    var maxSelectionCount: Int {
        return worker.maxSelectionCount
    }

    var choiceType: ChoiceWorker.ChoiceType {
        return worker.choiceType
    }

    var sectionCount: Int {
        return worker.sectionCount
    }

    var selectedCount: Int {
        return worker.selectedCount
    }

    func selectedCount(in section: Int) -> Int {
        return worker.selectedCount(in: section)
    }

    func numberOfItems(in section: Int) -> Int {
        return worker.numberOfItems(in: section)
    }

    func replace(_ item: Choice?, at indexPath: IndexPath) {
        worker.replace(item, at: indexPath)
    }

    func numberOfRows(in section: Int) -> Int {
        return worker.numberOfRows(in: section)
    }

    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        return worker.rowHeight(at: indexPath)
    }

    func isParentNode(atIndexPath indexPath: IndexPath) -> Bool {
        return worker.isParentNode(atIndexPath: indexPath)
    }

    func setIsOpen(_ isOpen: Bool, in section: Int) {
        worker.setIsOpen(isOpen, in: section)
    }

    func node(in section: Int) -> CollapsableNode {
        return worker.node(in: section)
    }

    func item(at indexPath: IndexPath) -> Choice {
        return worker.item(at: indexPath)
    }
}
