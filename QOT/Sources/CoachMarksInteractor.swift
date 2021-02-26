//
//  CoachMarksInteractor.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CoachMarksInteractor {

    // MARK: - Properties
    private lazy var worker = CoachMarksWorker()
    private let presenter: CoachMarksPresenterInterface
    private let router: CoachMarksRouterInterface
    private var contentCategory: QDMContentCategory?
    var currentPage: Int = .zero
    // MARK: - Init
    init(presenter: CoachMarksPresenterInterface, router: CoachMarksRouterInterface) {
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        worker.getContentCategory(ContentCategory.CoachMarks.rawValue) { [weak self] (contentCategory) in
            self?.contentCategory = contentCategory
            let models = CoachMark.Step.allCases.compactMap { self?.createPresentationModel($0, contentCategory) }
            self?.presenter.updateView(models)
        }
    }
}

// MARK: - CoachMarksInteractorInterface
extension CoachMarksInteractor: CoachMarksInteractorInterface {

    func saveCoachMarksViewed() {
        worker.saveCoachMarksViewed()
    }

    func askNotificationPermissions(_ completion: @escaping () -> Void) {
        worker.notificationRequestType { [weak self] (type) in
            guard let type = type else {
                completion()
                return
            }
            self?.router.showNotificationPersmission(type: type, completion: completion)
        }
    }
}

// MARK: - Private  
private extension CoachMarksInteractor {
    func createPresentationModel(_ step: CoachMark.Step,
                                 _ contentCategory: QDMContentCategory?) -> CoachMark.PresentationModel {
        let content = contentCategory?.contentCollections.filter { $0.remoteID == step.contentId }.first
        return CoachMark.PresentationModel(step: step, content: content)
    }
}
