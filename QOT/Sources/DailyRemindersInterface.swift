//
//  DailyRemindersInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol DailyRemindersViewControllerInterface: class {
    func setupView()
    func reloadTableView()
}

protocol DailyRemindersPresenterInterface {
    func setupView()
    func reloadTableView()
}

protocol DailyRemindersInteractorInterface: Interactor {
    func generateItems()
    func isParentNode(atIndexPath indexPath: IndexPath) -> Bool
    func node(in section: Int) -> DailyRemindersModel
    func setIsOpen(_ isOpen: Bool, in section: Int)
    func item(at indexPath: IndexPath) -> ReminderSetting
    var sectionCount: Int { get }
    func numberOfRows(in section: Int) -> Int
    var headerTitle: String { get }
    func setIsExpanded(_ isExpanded: Bool, in indexPath: IndexPath)
    func isExpandedChild(atIndexPath indexPath: IndexPath) -> Bool
}

protocol DailyRemindersRouterInterface {
    func dismiss()
}
