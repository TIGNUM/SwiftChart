//
//  MyVisionPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionPresenter {

    private weak var viewController: MyVisionViewControllerInterface?
    private let options: [LaunchOption: String?]

    init(viewController: MyVisionViewControllerInterface, options: [LaunchOption: String?]? = nil) {
        self.viewController = viewController
        self.options = options ?? [:]
    }
}

extension MyVisionPresenter: MyVisionPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }

    func load(_ myVision: QDMToBeVision?) {
        viewController?.load(myVision)
    }
}
