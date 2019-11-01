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
    private var contentCategory: QDMContentCategory?

    // MARK: - Init
    init(presenter: CoachMarksPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        worker.getContentCategory(ContentCategory.CoachMarks.rawValue) { [weak self] (contentCategory) in
            self?.contentCategory = contentCategory
            if let presentationModel = self?.createPresentationModel(CoachMark.Step.know, contentCategory) {
                self?.presenter.updateView(presentationModel)
            }
        }
    }
}

// MARK: - CoachMarksInteractorInterface
extension CoachMarksInteractor: CoachMarksInteractorInterface {
    func loadNextStep(page: Int) {
        updateView(page + 1)
    }

    func loadPreviousStep(page: Int) {
        updateView(page - 1)
    }
}

// MARK: - Private  
private extension CoachMarksInteractor {
    func updateView(_ page: Int) {
        if let step = CoachMark.Step(rawValue: page) {
            let presentationModel = createPresentationModel(step, contentCategory)
            presenter.updateView(presentationModel)
        }
    }

    func createPresentationModel(_ step: CoachMark.Step,
                                 _ contentCategory: QDMContentCategory?) -> CoachMark.PresentationModel {
        let content = contentCategory?.contentCollections.filter { $0.remoteID == step.contentId }.first
        return CoachMark.PresentationModel(step: step, content: content)
    }
}
