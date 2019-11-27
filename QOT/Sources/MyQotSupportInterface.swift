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
    func title(at indexPath: IndexPath) -> String
    func subtitle(at indexPath: IndexPath) -> String
    func handleSelection(for indexPath: IndexPath)
    var supportText: String { get }
}

protocol MyQotSupportRouterInterface {
    func handleSelection(for item: MyQotSupportModel.MyQotSupportModelItem, email: String)
    func presentSupportNovartis(header: String?, subHeader: String?)
}
