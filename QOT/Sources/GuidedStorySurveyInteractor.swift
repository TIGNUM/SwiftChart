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

    // MARK: - Init
    init(presenter: GuidedStorySurveyPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        let key = worker.currentQuestionKey
        worker.getQuestions { [weak self] in
            self?.presenter.setupView()
            self?.presenter.setQuestion(self?.worker.question(for: key))
        }
    }
}

// MARK: - GuidedStorySurveyInteractorInterface
extension GuidedStorySurveyInteractor: GuidedStorySurveyInteractorInterface {
    var rowCount: Int {
        return currentQuestion?.answers.count ?? .zero
    }

    func title(at index: Int) -> String? {
        return currentQuestion?.answers.at(index: index)?.title
    }

    func subtitle(at index: Int) -> String? {
        return currentQuestion?.answers.at(index: index)?.subtitle
    }

    func onColor(at index: Int) -> UIColor {
        return .blue
    }

    func isOn(at index: Int) -> Bool {
        return false
    }
}

private extension GuidedStorySurveyInteractor {
    var currentQuestion: QDMQuestion? {
        return worker.question(for: currentQuestionKey)
    }
}
