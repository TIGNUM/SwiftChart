//
//  DailyRemindersInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class DailyRemindersInteractor {

    // MARK: - Properties
    private lazy var worker = DailyRemindersWorker()
    private let presenter: DailyRemindersPresenterInterface!

    // MARK: - Init
    init(presenter: DailyRemindersPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - DailyRemindersInteractorInterface
extension DailyRemindersInteractor: DailyRemindersInteractorInterface {

    func generateItems() {
        worker.generateItems { [weak self] in
            self?.presenter.reloadTableView()
        }
    }

    func isParentNode(atIndexPath indexPath: IndexPath) -> Bool {
        return worker.isParentNode(atIndexPath: indexPath)
    }

    func setIsOpen(_ isOpen: Bool, in section: Int) {
        worker.setIsOpen(isOpen, in: section)
    }

    func isExpanded(_ isExpanded: Bool, in indexPath: IndexPath) {
        worker.setIsExpanded(isExpanded, in: indexPath)
    }

    func isExpandedChild(atIndexPath indexPath: IndexPath) -> Bool {
        worker.isExpandedChild(atIndexPath: indexPath)
    }

    func setIsExpanded(_ isExpanded: Bool, in indexPath: IndexPath) {
        worker.setIsExpanded(isExpanded, in: indexPath)
    }

    func node(in section: Int) -> DailyRemindersModel {
        return worker.node(in: section)
    }

    func item(at indexPath: IndexPath) -> ReminderSetting {
        return worker.item(at: indexPath)
    }

    var sectionCount: Int {
        return worker.sectionCount
    }

    func numberOfRows(in section: Int) -> Int {
        return worker.numberOfRows(in: section)
    }

    var headerTitle: String {
        return worker.headerTitle
    }
}
