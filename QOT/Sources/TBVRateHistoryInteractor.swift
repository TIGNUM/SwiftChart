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
    private let displayType: TBVGraph.DisplayType
    private let team: QDMTeam?

    // MARK: - Init
    init(_ presenter: TBVRateHistoryPresenterInterface,
         _ displayType: TBVGraph.DisplayType,
         _ team: QDMTeam?) {
        self.presenter = presenter
        self.displayType = displayType
        self.team = team
        self.worker = TBVRateHistoryWorker(displayType, team: team)
    }

    func viewDidLoad() {
        worker.getData { [weak self] (report) in
            self?.presenter.setupView(with: report)
        }
    }
}

// MARK: - MyToBeVisionTrackerInteractorInterface
extension TBVRateHistoryInteractor: TBVRateHistoryInteractorInterface {
    var getDisplayType: TBVGraph.DisplayType {
        return displayType
    }

    var getDataModel: ToBeVisionReport? {
        return worker.dataModel
    }

    var numberOfRows: Int {
        return worker.sentences.count
    }

    var subtitle: String {
        return team == nil ? worker.subtitle : worker.teamSubtitle
    }

    var title: String {
        return team == nil ? worker.title : worker.teamHeader
    }

    var graphTitle: String {
        return team == nil ? worker.graphTitle.uppercased() : worker.teamTitle.uppercased()
    }

    var average: [Date: Double] {
        return worker.average
    }

    var days: [Date] {
        return worker.days
    }

    var selectedDate: Date {
        return worker.selectedDate
    }

    var isUserInteractionEnabled: Bool {
        return team != nil
    }

    func setSelection(for date: Date) {
        worker.setSelection(for: date)
    }

    func sentence(in row: Int) -> QDMToBeVisionSentence? {
        return worker.sentences.at(index: row)
    }
}
