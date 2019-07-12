//
//  MyQotSupportInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyQotSupportViewControllerInterface: class {
    func setupView()
}

protocol MyQotSupportPresenterInterface {
    func setupView()
}

protocol MyQotSupportInteractorInterface: Interactor {
    func trackingKeys(at indexPath: IndexPath) -> String
    func itemCount() -> Int
    func item(at indexPath: IndexPath) -> MyQotSupportModel.MyQotSupportModelItem?
    func title(at indexPath: IndexPath, _ completion: @escaping(String) -> Void)
    func subtitle(at indexPath: IndexPath, _ completion: @escaping(String) -> Void)
    func contentCollection(_ item: MyQotSupportModel.MyQotSupportModelItem, _ completion: @escaping(QDMContentCollection?) -> Void)
    func handleSelection(for indexPath: IndexPath)
    func supportText(_ completion: @escaping(String) -> Void)
}

protocol MyQotSupportRouterInterface {
    func handleSelection(for item: MyQotSupportModel.MyQotSupportModelItem, email: String)
}
