//
//  TeamVisionTrackerDetailsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TeamVisionTrackerDetailsViewControllerInterface: class {
    func setupView()
    func setupDates(firstDate: String?, secondDate: String?, thirdDate: String?, selectedIndex: Int)
    func setupSentence(_ sentence: String)
}

protocol TeamVisionTrackerDetailsPresenterInterface {
    func setupView(report: ToBeVisionReport, sentence: QDMToBeVisionSentence, selectedDate: Date)
}

protocol TeamVisionTrackerDetailsInteractorInterface: Interactor {
    var dataEntries1: [BarEntry] { get }
    var dataEntries2: [BarEntry] { get }
    var dataEntries3: [BarEntry] { get }
}

protocol TeamVisionTrackerDetailsRouterInterface {
    func dismiss()
}
