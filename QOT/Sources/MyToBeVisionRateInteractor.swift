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
    private lazy var isoDate = worker.trackerPoll?.createdAt ?? Date()

    init(presenter: MyToBeVisionRatePresenterInterface,
         worker: MyToBeVisionRateWorker,
         router: MyToBeVisionRateRouter) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
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

    @objc func dismiss() {
        presenter.dismiss(animated: true, completion: nil)
    }
}

extension MyToBeVisionRateInteractor: MyToBeVisionRateInteracorInterface {
    func addRating(for questionId: Int, value: Int) {
        worker.addRating(for: questionId, value: value, isoDate: isoDate)
    }

    func saveQuestions() {
        worker.saveQuestions {[weak self] in
            guard self?.worker.team == nil else {
                self?.showAlert()
                return
            }
            self?.showTBVData()
        }
    }

    func showTBVData() {
        worker.getRatingReport { [weak self] (report) in
            self?.worker.getToBeVision { [weak self] (_, toBeVision) in
                self?.presenter.dismiss(animated: true) {
                    self?.router.showTBVData(shouldShowNullState: report?.dates.isEmpty == true,
                                             visionId: toBeVision?.remoteID)
                }
            }
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
                                        action: #selector(dismiss),
                                        handler: nil)
        presenter.showAlert(action: seeResults, days: worker.trackerPoll?.remainingDays)
    }

    var team: QDMTeam? {
        worker.team
    }
}
