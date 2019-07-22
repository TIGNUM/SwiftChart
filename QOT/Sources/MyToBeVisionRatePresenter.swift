//
//  MyToBeVisionRatePresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionRatePresenter {

    private weak var viewController: MyToBeVisionRateViewControllerInterface?

    init(viewController: MyToBeVisionRateViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyToBeVisionRatePresenter: MyToBeVisionRatePresenterInterface {

    func setupView(questions: [RatingQuestionViewModel.Question]) {
        viewController?.setupView(questions: questions)
    }

    func hideTimerView(completion: @escaping (() -> Void)) {
        viewController?.hideTimerView(completion: completion)
    }

    func showScreenLoader() {
        viewController?.showScreenLoader()
    }

    func hideScreenLoader() {
        viewController?.hideScreenLoader()
    }

    func showCountDownView(_ view: UIView?) {
        viewController?.showCountDownView(view)
    }
}
