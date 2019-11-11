//
//  TBVRateHistoryInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TBVRateHistoryInteractor {

    // MARK: - Properties
    private let worker: TBVRateHistoryWorker
    private let presenter: TBVRateHistoryPresenterInterface
    private let displayType: TBVRateHistory.DisplayType

    // MARK: - Init
    init(_ presenter: TBVRateHistoryPresenterInterface, _ displayType: TBVRateHistory.DisplayType) {
        self.presenter = presenter
        self.displayType = displayType
        self.worker = TBVRateHistoryWorker(displayType)
    }

    func viewDidLoad() {
        worker.getData { [weak self] (report) in
            self?.presenter.setupView(with: report)
        }
    }
}

// MARK: - MyToBeVisionTrackerInteractorInterface
extension TBVRateHistoryInteractor: TBVRateHistoryInteractorInterface {
    var getDisplayType: TBVRateHistory.DisplayType {
        return displayType
    }

    var getViewModel: ToBeVisionReport? {
        return worker.dataModel
    }

    var numberOfRows: Int {
        return worker.answers().count
    }

    var subtitle: String {
        return worker.subtitle
    }

    var title: String {
        return worker.subtitle
    }

    var graphTitle: String {
        return worker.graphTitle.uppercased()
    }

    var average: [Date: Double] {
        return worker.average
    }

    var days: [Date] {
        return worker.days
    }

    func setSelection(for date: Date) {
        worker.setSelection(for: date)
    }

    func sentence(in row: Int) -> QDMToBeVisionSentence? {
        return worker.answers().at(index: row)
    }
}
