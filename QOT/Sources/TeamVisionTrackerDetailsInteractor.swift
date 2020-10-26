//
//  TeamVisionTrackerDetailsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamVisionTrackerDetailsInteractor {

    // MARK: - Properties
    private lazy var worker = TeamVisionTrackerDetailsWorker(report: report,
                                                             selectedSentence: sentence.text)
    private let presenter: TeamVisionTrackerDetailsPresenterInterface!
    private let report: ToBeVisionReport
    private let sentence: QDMToBeVisionSentence

    // MARK: - Init
    init(presenter: TeamVisionTrackerDetailsPresenterInterface,
         report: ToBeVisionReport,
         sentence: QDMToBeVisionSentence) {
        self.presenter = presenter
        self.report = report
        self.sentence = sentence
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(report: report, sentence: sentence)
    }
}

// MARK: - TeamVisionTrackerDetailsInteractorInterface
extension TeamVisionTrackerDetailsInteractor: TeamVisionTrackerDetailsInteractorInterface {

    var dataEntries1: [BarEntry] {
        return worker.dataEntries1
    }

    var dataEntries2: [BarEntry] {
        return worker.dataEntries2
    }

    var dataEntries3: [BarEntry] {
        return worker.dataEntries3
    }
}
