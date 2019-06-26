//
//  ChoiceInterface.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol ChoiceViewControllerInterface: class {
    func setupView()
    func reloadTableView()
}

protocol ChoicePresenterInterface {
    func setupView()
    func reloadTableView()
}

protocol ChoiceInteractorInterface: Interactor {
    func generateItems()
    var maxSelectionCount: Int { get }
    var choiceType: ChoiceWorker.ChoiceType { get }
    var sectionCount: Int { get }
    var selectedCount: Int { get }
    var selected: [Choice] { get }
    func selectedCount(in section: Int) -> Int
    func numberOfItems(in section: Int) -> Int
    func replace(_ item: Choice?, at indexPath: IndexPath)
    func numberOfRows(in section: Int) -> Int
    func rowHeight(at indexPath: IndexPath) -> CGFloat
    func isParentNode(atIndexPath indexPath: IndexPath) -> Bool
    func setIsOpen(_ isOpen: Bool, in section: Int)
    func node(in section: Int) -> CollapsableNode
    func item(at indexPath: IndexPath) -> Choice
}

protocol ChoiceRouterInterface {

}
