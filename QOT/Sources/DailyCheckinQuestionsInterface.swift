//
//  DailyCheckinQuestionsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol DailyCheckinQuestionsViewControllerInterface: class {
    func setupView()
    func showQuestions()
}

protocol DailyCheckinQuestionsPresenterInterface {
    func setupView()
    func showQuestions()
}

protocol DailyCheckinQuestionsInteractorInterface: Interactor {
    var questions: [RatingQuestionViewModel.Question] { get }
    var answeredQuestionCount: Int { get }
    func dismiss()
    func saveAnswers()
}

protocol DailyCheckinQuestionsRouterInterface {
    func dismiss()
}
