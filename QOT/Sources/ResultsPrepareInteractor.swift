//
//  ResultsPrepareInteractor.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareInteractor {

    // MARK: - Properties
    private lazy var worker = ResultsPrepareWorker()
    private let presenter: ResultsPreparePresenterInterface!
    private var preparation: QDMUserPreparation?
    private let resultType: ResultType
    private var editKey = Prepare.Key.benefits

    // MARK: - Init
    init(presenter: ResultsPreparePresenterInterface, _ preparation: QDMUserPreparation?, resultType: ResultType) {
        self.presenter = presenter
        self.preparation = preparation
        self.resultType = resultType
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        presenter.createListItems(preparation: preparation)
    }
}

// MARK: - ResultsPrepareInteractorInterface
extension ResultsPrepareInteractor: ResultsPrepareInteractorInterface {
    var sectionCount: Int {
        guard let level = preparation?.type else { return 0 }
        return ResultsPrepare.sectionCount(level: level)
    }

    func rowCount(in section: Int) -> Int {
        guard let level = preparation?.type else { return 0 }
        let strategyCount = ((preparation?.strategies.count ?? 0))
        if level == .LEVEL_CRITICAL && section == 8 {
            return strategyCount
        }
        if level == .LEVEL_DAILY && section == 7 {
            return strategyCount
        }
        return 1
    }

    func getDTViewModel(key: Prepare.Key, _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void) {
        editKey = key
        worker.getDTViewModel(key, preparation: preparation, completion)
    }

    func updateBenefits(_ benefits: String) {
        preparation?.benefits = benefits
        presenter.createListItems(preparation: preparation)
    }

    func updateIntentions(_ answerIds: [Int]) {
        switch editKey {
        case .feel:
            preparation?.feelAnswerIds = answerIds
            worker.getAnswers(answerIds: answerIds, key: editKey) { [weak self] (answers) in
                self?.preparation?.feelAnswers = answers
                self?.presenter.createListItems(preparation: self?.preparation)
            }
        case .know:
            preparation?.knowAnswerIds = answerIds
            worker.getAnswers(answerIds: answerIds, key: editKey) { [weak self] (answers) in
                self?.preparation?.knowAnswers = answers
                self?.presenter.createListItems(preparation: self?.preparation)
            }
        case .perceived:
            preparation?.preceiveAnswerIds = answerIds
            worker.getAnswers(answerIds: answerIds, key: editKey) { [weak self] (answers) in
                self?.preparation?.preceiveAnswers = answers
                self?.presenter.createListItems(preparation: self?.preparation)
            }
        default: break
        }
    }
}
