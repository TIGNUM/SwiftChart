//
//  CalendarEventSelectionInterface.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol CalendarEventSelectionViewControllerInterface: class {
    func setupView()
}

protocol CalendarEventSelectionPresenterInterface {
    func setupView()
}

protocol CalendarEventSelectionInteractorInterface: Interactor {}

protocol CalendarEventSelectionRouterInterface {
    func dismiss()
}
