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
}

protocol MyToBeVisionTrackerPresenterInterface {
    func setupView(with data: MYTBVDataViewModel)
}

protocol MyToBeVisionTrackerInteractorInterface: Interactor {
    var controllerType: MyToBeVisionTrackerWorker.ControllerType { get }
    func setSelection(for date: Date?) -> MYTBVDataViewModel?
}

protocol MyToBeVisionTrackerRouterInterface {}
