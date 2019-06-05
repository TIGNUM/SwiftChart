//
//  MyVisionEditDetailsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionEditDetailsPresenter {

    private weak var viewController: MyVisionEditDetailsControllerInterface?

    init(viewController: MyVisionEditDetailsControllerInterface) {
        self.viewController = viewController
    }
}

extension MyVisionEditDetailsPresenter: MyVisionEditDetailsPresenterInterface {
    func setupView(title: String, vision: String) {
        viewController?.setupView(title: title, vision: vision)
    }
 }
