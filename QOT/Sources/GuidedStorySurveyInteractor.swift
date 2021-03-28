//
//  GuidedStorySurveyInteractor.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class GuidedStorySurveyInteractor {

    // MARK: - Properties
    private lazy var worker = GuidedStorySurveyWorker()
    private let presenter: GuidedStorySurveyPresenterInterface!
    private var currentQuestionKey = Survey.QuestionKey.intro.rawValue

    // MARK: - Init
    init(presenter: GuidedStorySurveyPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        let key = currentQuestionKey
        worker.getQuestions { [weak self] in
            self?.presenter.setupView()
            self?.presenter.setQuestion(self?.worker.question(for: key))
        }
    }
}

// MARK: - GuidedStorySurveyInteractorInterface
extension GuidedStorySurveyInteractor: GuidedStorySurveyInteractorInterface {
    var rowCount: Int {
        return worker.question(for: currentQuestionKey)?.answers.count ?? .zero
    }
}
