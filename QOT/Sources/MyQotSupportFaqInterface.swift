//
//  MyQotSupportFaqInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyQotSupportFaqViewControllerInterface: class {
    func setupView()
}

protocol MyQotSupportFaqPresenterInterface {
    func setupView()
}

protocol MyQotSupportFaqInteractorInterface: Interactor {
    func faqHeaderText(_ completion: @escaping(String) -> Void)
    var itemCount: Int { get }
    func item(at indexPath: IndexPath) -> QDMContentCollection
    func trackingID(at indexPath: IndexPath) -> Int
    func title(at indexPath: IndexPath) -> String
    func presentContentItemSettings(contentID: Int)
}

protocol MyQotSupportFaqRouterInterface {
    func presentContentItemSettings(contentID: Int)
}
