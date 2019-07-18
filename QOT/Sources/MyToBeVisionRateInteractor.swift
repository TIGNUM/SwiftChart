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

    init(presenter: MyToBeVisionRatePresenterInterface,
         worker: MyToBeVisionRateWorker,
         router: MyToBeVisionRateRouter) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    private func getQuestions(_ completion: @escaping (_ tracks: [MyToBeVisionRateViewModel.Question]) -> Void) {
        guard let questions = worker.questions else {
            showScreenLoader()
            worker.getQuestions {[weak self] (tracks, isInitialized, error) in
                self?.hideScreenLoader()
                guard let finalTracks = tracks else {
                    completion([])
                    return
                }
                completion(finalTracks)
            }
            return
        }
        completion(questions)
    }
}

extension MyToBeVisionRateInteractor: MyToBeVisionRateInteracorInterface {

    func viewDidLoad() {
        if !worker.skipCounterView {
            countDownView()
        } else {
            getQuestions {[weak self] (questions) in
                self?.presenter.setupView(questions: questions)
            }
        }
    }

    func addRating(for questionId: Int, value: Int) {
        worker.addRating(for: questionId, value: value)
    }

    func saveQuestions() {
        worker.saveQuestions()
    }

    func skipCountDownView() {
        getQuestions {[weak self] (questions) in
            self?.presenter.setupView(questions: questions)
        }
    }

    func hideTimerView(completion: @escaping (() -> Void)) {
        presenter.hideTimerView(completion: completion)
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

    func countDownView() {
        let view = worker.countDownView()
        presenter.showCountDownView(view)
    }
}
