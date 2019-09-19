//
//  PreparationWithMissingEventInterface.swift
//  QOT
//
//  Created by Sanggeon Park on 18.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol PreparationWithMissingEventViewControllerInterface: class {
    func reloadEvents()
    func update(title: String, text: String, removeButtonTitle: String, keepButtonTitle: String)
}

protocol PreparationWithMissingEventPresenterInterface {
    func reloadEvents()
    func update(title: String, text: String, removeButtonTitle: String, keepButtonTitle: String)
}

protocol PreparationWithMissingEventInteractorInterface: Interactor {

    func preparationRemoteId() -> Int?

    func preparationTitle() -> String

    func keepPreparation()

    func deletePreparation()

    func updatePreparation(with newEvent: QDMUserCalendarEvent)

    func eventAt(_ index: Int) -> QDMUserCalendarEvent

    func eventCount() -> Int
}

protocol PreparationWithMissingEventRouterInterface {
    func dismiss()
}
