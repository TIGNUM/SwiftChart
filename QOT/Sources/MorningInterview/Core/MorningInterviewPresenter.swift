//
//  MorningInterviewPresenter.swift
//  QOT
//
//  Created by Sam Wyndham on 19/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class MorningInterviewPresenter: MorningInterviewPresenterInterface {

    private weak var viewController: MorningInterviewViewControllerInterface?

    init(viewController: MorningInterviewViewControllerInterface) {
        self.viewController = viewController
    }

    func presentQuestions(_ questions: [MorningInterview.Question]) {
        viewController?.setQuestions(questions)
    }
}
