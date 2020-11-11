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
        // Listen about UpSync Daily Check In User Answers
        _ = NotificationCenter.default.addObserver(forName: .didFinishSynchronization,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didGetDataSyncResult(notification)
        }
    }

    private func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        if let questions = worker.questions, questions.isEmpty == false {
            completion(questions)
        } else {
            showScreenLoader()
            worker.getQuestions { [weak self] (questions) in
                if questions.isEmpty == false {
                    self?.hideScreenLoader()
                }
                completion(questions)
            }
        }
    }

    @objc private func didGetDataSyncResult(_ notification: Notification) {
        guard let result = notification.object as? SyncResultContext else { return }
        switch result.dataType {
        case .TEAM_TO_BE_VISION_TRACKER_POLL where result.syncRequestType == .DOWN_SYNC && result.hasUpdatedContent:
            if worker.questions?.isEmpty != true { // reload if there is no questions.
                getQuestions { [weak self] (questions) in
                    self?.presenter.setupView(questions: questions)
                }
            }
        default:
            break
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
            self?.presenter.dismiss(animated: true, completion: nil)
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
