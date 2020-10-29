//
//  MyToBeVisionRateInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyToBeVisionRateInteractor: WorkerTeam {

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

    @objc func showTracker() {
        presenter.dismiss(animated: true) {
            self.router.showTracker(for: self.worker.team)
        }
    }
}

extension MyToBeVisionRateInteractor: MyToBeVisionRateInteracorInterface {
    func addRating(for questionId: Int, value: Int) {
        worker.addRating(for: questionId, value: value, isoDate: isoDate)
    }

    func saveQuestions() {
        worker.saveQuestions {[weak self] in
            self?.showAlert()
        }
    }

    func showScreenLoader() {
        presenter.showScreenLoader()
    }

    func hideScreenLoader() {
        presenter.hideScreenLoader()
    }

    func showAlert() {
        let seeResults = QOTAlertAction(title: AppTextService.get(.alert_tracker_poll_answers_submitted_cta),
                                        target: self,
                                        action: #selector(showTracker),
                                        handler: nil)
        presenter.showAlert(action: seeResults, days: worker.trackerPoll?.remainingDays)
    }

    var team: QDMTeam? {
        worker.team
    }
}
