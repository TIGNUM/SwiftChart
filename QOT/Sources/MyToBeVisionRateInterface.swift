//
//  MyToBeVisionRateInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyToBeVisionRateViewControllerInterface: class {
    func setupView(questions: [MyToBeVisionRateViewModel.Question])
    func showCountDownView(_ view: UIView?)
    func hideTimerView(completion: @escaping (() -> Void))
    func showScreenLoader()
    func hideScreenLoader()
}

protocol MyToBeVisionRatePresenterInterface {
    func setupView(questions: [MyToBeVisionRateViewModel.Question])
    func showCountDownView(_ view: UIView?)
    func hideTimerView(completion: @escaping (() -> Void))
    func showScreenLoader()
    func hideScreenLoader()
}

protocol MyToBeVisionRateInteracorInterface: Interactor {
    func addRating(for questionId: Int, value: Int)
    func saveQuestions()
    func dismiss()
    func skipCountDownView()
    func countDownView()
    func hideTimerView(completion: @escaping (() -> Void))
    func showScreenLoader()
    func hideScreenLoader()
}

protocol MyToBeVisionRateRouterInterface {
    func dismiss()
}
