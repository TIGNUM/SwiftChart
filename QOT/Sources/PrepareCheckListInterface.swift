//
//  PrepareCheckListInterface.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol PrepareCheckListViewControllerInterface: class {
    func setupView()
    func registerTableViewCell(for checkListType: PrepareCheckListType)
}

protocol PrepareCheckListPresenterInterface {
    func setupView()
    func registerTableViewCell(for checkListType: PrepareCheckListType)
}

protocol PrepareCheckListInteractorInterface: Interactor {
    var type: PrepareCheckListType { get }
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> PrepareCheckListItem?
    func attributedText(title: String?, itemFormat: ContentItemFormat?) -> NSAttributedString?
    func rowHeight(at indexPath: IndexPath) -> CGFloat
    func hasListMark(at indexPath: IndexPath) -> Bool
    func hasBottomSeperator(at indexPath: IndexPath) -> Bool
    func hasHeaderMark(at indexPath: IndexPath) -> Bool
    func presentRelatedArticle(readMoreID: Int)
    func didClickSaveAndContinue()
    func openEditStrategyView()
}

protocol PrepareCheckListRouterInterface {
    func presentRelatedArticle(readMoreID: Int)
    func didClickSaveAndContinue()
    func openEditStrategyView(services: Services, relatedStrategies: [ContentCollection], selectedIDs: [Int])
}
