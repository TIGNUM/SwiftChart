//
//  MyToBeVisionTrackerInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyToBeVisionTrackerViewControllerInterface: class {
    func setupView(with data: MYTBVDataViewModel)
    func showScreenLoader()
    func hideScreenLoader()
}

protocol MyToBeVisionTrackerPresenterInterface {
    func setupView(with data: MYTBVDataViewModel)
    func showScreenLoader()
    func hideScreenLoader()
}

protocol MyToBeVisionTrackerInteractorInterface: Interactor {
    var controllerType: MyToBeVisionTrackerWorker.ControllerType { get }
    func setSelection(for date: Date?) -> MYTBVDataViewModel?
    func showScreenLoader()
    func hideScreenLoader()
    func formattedHeaderView(title: String) -> NSAttributedString?
    func formattedSubHeading(title: String) -> NSAttributedString?
}

protocol MyToBeVisionTrackerRouterInterface {}
