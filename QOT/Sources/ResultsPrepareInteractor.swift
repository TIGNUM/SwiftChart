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
    private let preparation: QDMUserPreparation?
    private let resultType: ResultType

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
        let strategyCount = ((preparation?.strategies.count ?? 0) + 1) + 1
        if level == .LEVEL_CRITICAL && section == 8 {
            return strategyCount
        }
        if level == .LEVEL_DAILY && section == 7 {
            return strategyCount
        }
        return 1
    }
}
