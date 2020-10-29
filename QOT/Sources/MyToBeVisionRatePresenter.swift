//
//  MyToBeVisionRatePresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

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

    func showScreenLoader() {
        viewController?.showScreenLoader()
    }

    func hideScreenLoader() {
        viewController?.hideScreenLoader()
    }

    func showAlert(action: QOTAlertAction, days: Int?)  {
        viewController?.showAlert(action: action, days: days)
    }

    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        viewController?.dismiss(animated: flag, completion: completion)
    }
}
