//
//  MyQotAboutUsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAboutUsRouter: BaseRouter, MyQotAboutUsRouterInterface {
    func handleSelection(for item: MyQotAboutUsModel.Item) {
        super.presentContent(item.primaryKey)
    }
}
