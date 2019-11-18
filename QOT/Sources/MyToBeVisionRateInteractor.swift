//
//  MyToBeVisionRateInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionRateInteractor {

    let presenter: MyToBeVisionRatePresenterInterface
    let worker: MyToBeVisionRateWorker
    let router: MyToBeVisionRateRouter
    private let isoDate: Date

    init(presenter: MyToBeVisionRatePresenterInterface,
         worker: MyToBeVisionRateWorker,
         router: MyToBeVisionRateRouter,
         isoDate: Date) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.isoDate = isoDate
    }

    func viewDidLoad() {
        getQuestions { [weak self] (questions) in
            self?.presenter.setupView(questions: questions)
        }
    }

    private func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        if let questions = worker.questions {
            completion(questions)
        } else {
            showScreenLoader()
            worker.getQuestions { [weak self] (tracks) in
                self?.hideScreenLoader()
                completion(tracks)
            }
        }
    }
}

extension MyToBeVisionRateInteractor: MyToBeVisionRateInteracorInterface {
    func addRating(for questionId: Int, value: Int) {
        worker.addRating(for: questionId, value: value, isoDate: isoDate)
    }

    func saveQuestions() {
        worker.saveQuestions()
    }

    func showScreenLoader() {
        presenter.showScreenLoader()
    }

    func hideScreenLoader() {
        presenter.hideScreenLoader()
    }

    func dismiss() {
        router.dismiss()
    }
}
