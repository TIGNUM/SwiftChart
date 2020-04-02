//
//  CoachMarksInterface.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol CoachMarksViewControllerInterface: class {
    func setupView()
    func updateView(_ viewModels: [CoachMark.ViewModel])
}

protocol CoachMarksPresenterInterface {
    func setupView()
    func updateView(_ presentationModel: [CoachMark.PresentationModel])
}

protocol CoachMarksInteractorInterface: Interactor {
    func saveCoachMarksViewed()
    func askNotificationPermissions(_ completion: @escaping () -> Void)
    var currentPage: Int { get }
}

protocol CoachMarksRouterInterface {
    func navigateToTrack()
    func showNotificationPersmission(type: AskPermission.Kind, completion: (() -> Void)?)
}
