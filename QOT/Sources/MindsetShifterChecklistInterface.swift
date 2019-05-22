//
//  MindsetShifterChecklistInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MindsetShifterChecklistViewControllerInterface: class {
    func load(_ model: MindsetShifterChecklistModel)
}

protocol MindsetShifterChecklistPresenterInterface {
    func load(_ model: MindsetShifterChecklistModel)
}

protocol MindsetShifterChecklistInteractorInterface: Interactor {
    func didTapClose()
    func didTapSave()
}

protocol MindsetShifterChecklistRouterInterface {
    func dismiss()
}

protocol MindsetShifterChecklistWorkerInterface {
    var header: MindsetShifterChecklistModel.Section { get }
    var mindsetTrigger: MindsetShifterChecklistModel.Section { get }
    var mindsetReactions: MindsetShifterChecklistModel.Section { get }
    var positiveToNegative: MindsetShifterChecklistModel.Section { get }
    var vision: MindsetShifterChecklistModel.Section { get }
    var model: MindsetShifterChecklistModel { get }
    func saveChecklist()
}
