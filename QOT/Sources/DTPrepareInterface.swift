//
//  DTPrepareInterface.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI
import qot_dal

protocol DTPrepareViewControllerInterface: class {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind)
}

protocol DTPreparePresenterInterface {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind)
}

protocol DTPrepareInteractorInterface: Interactor {
    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void)

    func getUserPreparation(event: DTViewModel.Event?,
                            calendarEvent: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void)

    func getUserPreparation(userInput: String?,
                            event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void)

    func setCreatedCalendarEvent(_ event: EKEvent?)
}

protocol DTPrepareRouterInterface {
    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?)
    func presentPrepareResults(_ contentId: Int)
    func presentPrepareResults(_ preparation: QDMUserPreparation?, canDelete: Bool)
    func presentCalendarPermission(_ permissionType: AskPermission.Kind)
    func presentEditEventController()
}
