//
//  DailyBriefInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyBriefInteractor {

    // MARK: - Properties

    private let worker: DailyBriefWorker
    private let presenter: DailyBriefPresenterInterface
    private let router: DailyBriefRouterInterface

    // MARK: - Init

    init(worker: DailyBriefWorker,
        presenter: DailyBriefPresenterInterface,
        router: DailyBriefRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }
    func viewDidLoad() {
    }

}

// MARK: - DailyBriefInteractorInterface

extension DailyBriefInteractor: DailyBriefInteractorInterface {

    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void)) {
        worker.latestWhatsHotCollectionID(completion: completion)
    }

    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void)) {
        worker.latestWhatsHotContent(completion: completion)
    }
    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void)) {
        worker.getContentCollection(completion: completion)
    }

    func createLatestWhatsHotModel(completion: @escaping ((WhatsHotLatestCellViewModel?)) -> Void) {
        worker.createLatestWhatsHotModel(completion: completion)
    }

    func randomQuestionModel(completion: @escaping ((QuestionCellViewModel)?) -> Void) {
        worker.randomQuestionModel(completion: completion)
    }

    func createFactsModel(completion: @escaping ((GoodToKnowCellViewModel)?) -> Void) {
        worker.createFactsModel(completion: completion)
    }

    func lastMessage(completion: @escaping ((FromTignumCellViewModel)?) -> Void) {
        worker.lastMessage(completion: completion)
    }

    func createThoughtsModel(completion: @escaping ((ThoughtsCellViewModel)?) -> Void) {
        worker.createThoughtsModel(completion: completion)
    }

    func getDepartureModel(completion: @escaping ((DepartureInfoCellViewModel)?) -> Void) {
        worker.getDepartureModel(completion: completion)
    }

    func presentWhatsHotArticle(selectedID: Int) {
        router.presentWhatsHotArticle(selectedID: selectedID)
    }

    func getFeastModel(completion: @escaping ((FeastCellViewModel)?) -> Void) {
        worker.getFeastModel(completion: completion)
    }
}
