//
//  MindsetShifterChecklistConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MindsetShifterChecklistConfigurator: AppStateAccess {

    static func make(trigger: String, reactions: [String], lowPerformanceItems: [String], highPerformanceItems: [String])
        -> (MindsetShifterChecklistViewController) -> Void {
        return { (viewController) in
            let router = MindsetShifterChecklistRouter(viewController: viewController)
            let worker = MindsetShifterChecklistWorker(services: appState.services,
                                                       trigger: trigger,
                                                       reactions: reactions,
                                                       lowPerformanceItems: lowPerformanceItems,
                                                       highPerformanceItems: highPerformanceItems)
            let presenter = MindsetShifterChecklistPresenter(viewController: viewController)
            let interactor = MindsetShifterChecklistInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
