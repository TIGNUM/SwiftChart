//
//  DailyCheckinQuestionsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyCheckinQuestionsPresenter {

    // MARK: - Properties

    private weak var viewController: DailyCheckinQuestionsViewControllerInterface?

    // MARK: - Init

    init(viewController: DailyCheckinQuestionsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - DailyCheckinQuestionsInterface

extension DailyCheckinQuestionsPresenter: DailyCheckinQuestionsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func showQuestions() {
        viewController?.showQuestions()
    }
}
