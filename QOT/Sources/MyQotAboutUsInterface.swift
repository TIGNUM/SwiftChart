//
//  MyQotAboutUsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

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
    func subtitle(at indexPath: IndexPath) -> String
    func contentCollection(_ item: MyQotAboutUsModel.MyQotAboutUsModelItem) -> ContentCollection?
    func handleSelection(for indexPath: IndexPath)
}

protocol MyQotAboutUsRouterInterface {
    func handleSelection(for item: MyQotAboutUsModel.MyQotAboutUsModelItem)
}
