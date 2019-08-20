//
//  MyQotMainInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotMainInteractor {

    // MARK: - Properties

    private let worker: MyQotMainWorker
    private let presenter: MyQotMainPresenterInterface
    private let router: MyQotMainRouterInterface

    // MARK: - Init

    init(worker: MyQotMainWorker,
         presenter: MyQotMainPresenterInterface,
         router: MyQotMainRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.present(for: worker.myQotSections())
        presenter.setupView()
    }
}

// MARK: - MyQotMainInteractorInterface

extension MyQotMainInteractor: MyQotMainInteractorInterface {

    func presentMyPreps() {
        router.presentMyPreps()
    }

    func presentMyProfile() {
        router.presentMyProfile()
    }

    func presentMySprints() {
        router.presentMySprints()
    }

    func presentMyToBeVision() {
        router.presentMyToBeVision()
    }

    func presentMyLibrary() {
        router.presentMyLibrary()
    }

    func nextPrep(completion: @escaping (String?) -> Void) {
        worker.nextPrep { (preparation) in
            completion(preparation)
        }
    }

    func nextPrepType(completion: @escaping (String?) -> Void) {
        worker.nextPrepType { ( preparation) in
            completion(preparation)
        }
    }

    func toBeVisionDate(completion: @escaping (Date?) -> Void) {
        worker.toBeVisionDate { (toBeVisionDate) in
            completion(toBeVisionDate)
        }
    }
    func getImpactReadinessScore(completion: @escaping(Double?) -> Void) {
        worker.getImpactReadinessScore(completion: completion)
    }

   func getSubtitles(completion: @escaping ([String?]) -> Void) {
    worker.getSubtitles(completion: completion)
    }

    func getUserName(completion: @escaping (String?) -> Void) {
        worker.getUserName(completion: completion)
    }
}
