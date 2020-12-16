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
    func showAlert(action: QOTAlertAction, days: Int?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

protocol MyToBeVisionRatePresenterInterface {
    func setupView(questions: [RatingQuestionViewModel.Question])
    func showScreenLoader()
    func hideScreenLoader()
    func showAlert(action: QOTAlertAction, days: Int?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

protocol MyToBeVisionRateInteracorInterface: Interactor {
    var questions: [RatingQuestionViewModel.Question] { get }
    func addRating(for questionId: Int, value: Int)
    func saveQuestions()
    func showScreenLoader()
    func hideScreenLoader()
    var team: QDMTeam? { get }
    func showAlert()
    var showBanner: Bool? { get }
}

protocol MyToBeVisionRateRouterInterface {
}
