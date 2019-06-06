//
//  MyQotSupportFaqInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotSupportFaqViewControllerInterface: class {
    func setupView(with title: String)
}

protocol MyQotSupportFaqPresenterInterface {
    func setupView(with title: String)
}

protocol MyQotSupportFaqInteractorInterface: Interactor {
    var faqHeaderText: String { get }
    var itemCount: Int { get }
    func item(at indexPath: IndexPath) -> ContentCollection
    func trackingID(at indexPath: IndexPath) -> Int
    func title(at indexPath: IndexPath) -> String
    func presentContentItemSettings(contentID: Int, pageName: PageName, pageTitle: String)
}

protocol MyQotSupportFaqRouterInterface {
    func presentContentItemSettings(contentID: Int, pageName: PageName, pageTitle: String)
}
