//
//  DailyCheckinStartInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 12.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol DailyCheckinStartViewControllerInterface: class {
    func setupView(title: String?, subtitle: String, buttonTitle: String?)
}

protocol DailyCheckinStartPresenterInterface {
    func setupView(title: String?, subtitle: String, buttonTitle: String?)
}

protocol DailyCheckinStartInteractorInterface: Interactor {
    func showQuestions()
}

protocol DailyCheckinStartRouterInterface {
    func showQuestions(_ data: [RatingQuestionViewModel.Question])
}
