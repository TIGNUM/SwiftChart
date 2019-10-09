//
//  MyQotSupportDetailsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyQotSupportDetailsViewControllerInterface: class {
    func setupView()
}

protocol MyQotSupportDetailsPresenterInterface {
    func setupView()
}

protocol MyQotSupportDetailsInteractorInterface: Interactor {
    var category: ContentCategory { get }
    var headerText: String { get }
    var itemCount: Int { get }
    func item(at indexPath: IndexPath) -> QDMContentCollection
    func trackingID(at indexPath: IndexPath) -> Int
    func title(at indexPath: IndexPath) -> String
    func presentContentItemSettings(contentID: Int)
}

protocol MyQotSupportDetailsRouterInterface {
    func presentContentItemSettings(contentID: Int)
}
