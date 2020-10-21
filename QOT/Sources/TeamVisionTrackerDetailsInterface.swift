//
//  TeamVisionTrackerDetailsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol TeamVisionTrackerDetailsViewControllerInterface: class {
    func setupView()
    func setupDates(firstDate: String?, secondDate: String?, thirdDate: String?)
}

protocol TeamVisionTrackerDetailsPresenterInterface {
    func setupView(report: ToBeVisionReport)
}

protocol TeamVisionTrackerDetailsInteractorInterface: Interactor {
    var dataEntries1: [BarEntry] { get }
    var dataEntries2: [BarEntry] { get }
    var dataEntries3: [BarEntry] { get }
}

protocol TeamVisionTrackerDetailsRouterInterface {
    func dismiss()
}
