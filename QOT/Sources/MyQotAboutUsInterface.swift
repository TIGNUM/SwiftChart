//
//  MyQotAboutUsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyQotAboutUsViewControllerInterface: class {
    func setupView(with title: String)
}

protocol MyQotAboutUsPresenterInterface {
    func setupView(with title: String)
}

protocol MyQotAboutUsInteractorInterface: Interactor {
    func trackingKeys(at indexPath: IndexPath) -> String
    func itemCount() -> Int
    func item(at indexPath: IndexPath) -> MyQotAboutUsModel.MyQotAboutUsModelItem?
    func title(at indexPath: IndexPath) -> String
    func contentCollection(item: MyQotAboutUsModel.MyQotAboutUsModelItem, _ completion: @escaping(QDMContentCollection?) -> Void)
    func handleSelection(for indexPath: IndexPath)
}

protocol MyQotAboutUsRouterInterface {
    func handleSelection(for item: MyQotAboutUsModel.MyQotAboutUsModelItem)
}
