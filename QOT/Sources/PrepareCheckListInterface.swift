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
}

protocol PrepareCheckListPresenterInterface {
    func setupView()
}

protocol PrepareCheckListInteractorInterface: Interactor {
    var rowCount: Int { get }
    func item(at indexPath: IndexPath) -> PrepareCheckListModel
    func attributedText(title: String?, itemFormat: ContentItemFormat?) -> NSAttributedString?
    func rowHeight(at indexPath: IndexPath) -> CGFloat
    func hasListMark(at indexPath: IndexPath) -> Bool
    func hasBottomSeperator(at indexPath: IndexPath) -> Bool
    func hasHeaderMark(at indexPath: IndexPath) -> Bool
}

protocol PrepareCheckListRouterInterface {}
