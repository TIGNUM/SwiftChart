//
//  SupportFAQInterface.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SupportFAQViewControllerInterface: class {
    func setupView()
}

protocol SupportFAQPresenterInterface {
    func setupView()
}

protocol SupportFAQInteractorInterface: Interactor {
    var itemCount: Int { get }
    func item(at indexPath: IndexPath) -> ContentCollection
    func title(at indexPath: IndexPath) -> NSAttributedString?
}
