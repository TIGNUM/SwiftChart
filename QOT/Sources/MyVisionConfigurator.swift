//
//  MyVisionConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionConfigurator {
    static func configure(viewController: MyVisionViewController) {
        let router = MyVisionRouter(viewController: viewController)
        let presenter = MyVisionPresenter(viewController: viewController)
        let interactor = MyVisionInteractor(presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
