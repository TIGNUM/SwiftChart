//
//  MyToBeVisionCountDownPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionCountDownPresenter {
    private weak var viewController: MyToBeVisionCountDownViewControllerInterface?

    init(viewController: MyToBeVisionCountDownViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyToBeVisionCountDownPresenter: MyToBeVisionCountDownPresenterInterface {
    func setupView(with timerValue: String) {
        viewController?.setupView(with: timerValue)
    }

    func updateText(with value: String) {
        viewController?.updateText(with: value)
    }
}
