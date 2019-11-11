//
//  TBVRateHistoryInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TBVRateHistoryViewControllerInterface: class {
    func setupView(with data: ToBeVisionReport)
}

protocol TBVRateHistoryPresenterInterface {
    func setupView(with data: ToBeVisionReport)
}

protocol TBVRateHistoryInteractorInterface: Interactor {
    var getDisplayType: TBVGraph.DisplayType { get }
    var getDataModel: ToBeVisionReport? { get }
    var subtitle: String { get }
    var title: String { get }
    var graphTitle: String { get }
    var average: [Date: Double] { get }
    var days: [Date] { get }
    var numberOfRows: Int { get }
    var selectedDate: Date { get }

    func setSelection(for date: Date)
    func sentence(in row: Int) -> QDMToBeVisionSentence?
}
