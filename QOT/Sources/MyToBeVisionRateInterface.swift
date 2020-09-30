//
//  MyToBeVisionRateInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyToBeVisionRateViewControllerInterface: class {
    func setupView(questions: [RatingQuestionViewModel.Question])
    func showScreenLoader()
    func hideScreenLoader()
}

protocol MyToBeVisionRatePresenterInterface {
    func setupView(questions: [RatingQuestionViewModel.Question])
    func showScreenLoader()
    func hideScreenLoader()
}

protocol MyToBeVisionRateInteracorInterface: Interactor {
    func addRating(for questionId: Int, value: Int)
    func saveQuestions()
    func dismiss()
    func showScreenLoader()
    func hideScreenLoader()
    var team: QDMTeam? { get }
}

protocol MyToBeVisionRateRouterInterface {
    func dismiss()
}
