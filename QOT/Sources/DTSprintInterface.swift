//
//  DTSprintInterface.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTSprintViewControllerInterface: class {
    func presentPermissionView(_ permissionType: AskPermission.Kind)
}

protocol DTSprintPresenterInterface {
    func presentPermissionView(_ permissionType: AskPermission.Kind)
}

protocol DTSprintInteractorInterface: Interactor {
    func isPresentedFromCoach() -> Bool
    func startSprintTomorrow(selection: DTSelectionModel)
    func stopActiveSprintAndStartNewSprint()
    func addSprintToQueue(selection: DTSelectionModel)
    func getSelectedSprintTitle() -> String?
    func getActiveSprint() -> QDMSprint?
}

protocol DTSprintRouterInterface {
    func openPermissionView(_ permissionType: AskPermission.Kind)
    func presentMySprintsViewController()
    func showMySprintsCards()
}
