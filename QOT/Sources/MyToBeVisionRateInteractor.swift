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
    var showBanner: Bool?
    private weak var synchronizationObserver: NSObjectProtocol?
    private lazy var isoDate = worker.trackerPoll?.createdAt ?? Date()

    init(presenter: MyToBeVisionRatePresenterInterface,
         worker: MyToBeVisionRateWorker,
         router: MyToBeVisionRateRouter,
         showBanner: Bool?) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.showBanner = showBanner
    }

    func viewDidLoad() {
        addObserver()
        getQuestions { [weak self] (questions) in
            self?.presenter.setupView(questions: questions)
        }
    }

    private func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        if let questions = worker.questions, questions.isEmpty == false {
            completion(questions)
        } else {
            showScreenLoader()
            worker.getQuestions { [weak self] (questions) in
                if questions.isEmpty == false {
                    self?.removeObserver()
                    self?.hideScreenLoader()
                }
                completion(questions)
            }
        }
    }

    func addObserver() {
        synchronizationObserver = NotificationCenter.default.addObserver(forName: .didFinishSynchronization,
                                                                         object: nil,
                                                                         queue: .main) { [weak self] notification in
            self?.didGetDataSyncResult(notification)
        }
    }

    func removeObserver() {
        if let synchronizationObserver = synchronizationObserver {
            NotificationCenter.default.removeObserver(synchronizationObserver)
        }
    }

    @objc private func didGetDataSyncResult(_ notification: Notification) {
        guard let result = notification.object as? SyncResultContext else { return }
        switch result.dataType {
        case .TEAM_TO_BE_VISION_TRACKER_POLL where result.syncRequestType == .DOWN_SYNC:
            getQuestions { [weak self] (questions) in
                self?.presenter.setupView(questions: questions)
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
            self?.showTBVData()
        }
    }

    func showTBVData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        var tmpReport: QDMToBeVisionRatingReport?
        var tmpVision: QDMToBeVision?
        worker.getRatingReport { (report) in
            tmpReport = report
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        worker.getToBeVision { (_, toBeVision) in
            tmpVision = toBeVision
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.presenter.dismiss(animated: true) {
                self?.router.showTBVData(shouldShowNullState: tmpReport?.dates.isEmpty == true,
                                         visionId: tmpVision?.remoteID)
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
