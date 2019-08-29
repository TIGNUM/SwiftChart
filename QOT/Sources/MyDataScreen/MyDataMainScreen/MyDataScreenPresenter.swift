//
//  MyDataScreenPresenter.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import JTAppleCalendar

final class MyDataScreenPresenter {

    // MARK: - Properties
    private weak var viewController: MyDataScreenViewControllerInterface?

    // MARK: - Init
    init(viewController: MyDataScreenViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyDataScreenInterface
extension MyDataScreenPresenter: MyDataScreenPresenterInterface {
    func present(for myDataSection: MyDataScreenModel) {
        viewController?.setup(for: myDataSection)
    }

    func setupView() {
        viewController?.setupView()
    }

    func showImpactReadinessView(calendar: JTAppleCalendarView, withValue: Double, forCellState: CellState, forCell: MyDataHeatMapDateCell) {
        viewController?.showImpactReadinessView(calendar: calendar, withValue: withValue, forCellState: forCellState, forCell: forCell)
    }

    func hideImpactReadinessView(calendar: JTAppleCalendarView, forCell: MyDataHeatMapDateCell) {
        viewController?.hideImpactReadinessView(calendar: calendar, forCell: forCell)
    }

    func updateHeaderDateLabel(forSection: MyDataSection, withFirstDay: Date, andLastDay: Date) {
        viewController?.updateHeaderDateLabel(forSection: forSection, withFirstDay: withFirstDay, andLastDay: andLastDay)
    }

    func dataSourceFinished(firstLoad: Bool) {
        viewController?.dataSourceFinished(firstLoad: firstLoad)
    }
}
