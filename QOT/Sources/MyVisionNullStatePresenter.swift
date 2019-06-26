//
//  MyVisionNullStatePresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionNullStatePresenter {

    private weak var viewController: MyVisionNullStateViewControllerInterface?

    init(viewController: MyVisionNullStateViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyVisionNullStatePresenter: MyVisionNullStatePresenterInterface {
    func setupView() {

    }
}
