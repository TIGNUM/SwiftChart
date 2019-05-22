//
//  MindsetShifterChecklistWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterChecklistWorker {

    // MARK: - Properties

    private let services: Services
    private let trigger: String
    private let reactions: [String]
    private let lowPerformanceItems: [String]

    // MARK: - Init

    init(services: Services,
         trigger: String,
         reactions: [String],
         lowPerformanceItems: [String]) {
        self.services = services
        self.trigger = trigger
        self.reactions = reactions
        self.lowPerformanceItems = lowPerformanceItems
    }
}

// MARK: - MindsetShifterChecklistWorkerInterface

extension MindsetShifterChecklistWorker: MindsetShifterChecklistWorkerInterface {

    var header: MindsetShifterChecklistModel.Section {
        return MindsetShifterChecklistModel.Section.header(title: services.contentService.mindsetShifterHeaderTitle,
                                                           subtitle: services.contentService.mindsetShifterHeaderSubtitle)
    }

    var mindsetTrigger: MindsetShifterChecklistModel.Section {
        return MindsetShifterChecklistModel.Section.trigger(title: services.contentService.mindsetShifterTriggerTitle,
                                                            item: trigger)
    }

    var mindsetReactions: MindsetShifterChecklistModel.Section {
        return MindsetShifterChecklistModel.Section.reactions(title: services.contentService.mindsetShifterReactionsTitle,
                                                              items: ["item1", "item2", "item3"])
    }

    var positiveToNegative: MindsetShifterChecklistModel.Section {
        let title = services.contentService.mindsetShifterNegativeToPositiveTitle
        let lowTitle = services.contentService.mindsetShifterNegativeToPositiveLowTitle
        let highTitle = services.contentService.mindsetShifterNegativeToPositiveHighTitle
        return MindsetShifterChecklistModel.Section.fromNegativeToPositive(title: title,
                                                                           lowTitle: lowTitle,
                                                                           lowItems: lowPerformanceItems,
                                                                           highTitle: highTitle,
                                                                           highItems: ["item1", "item2", "item3"])
    }

    var vision: MindsetShifterChecklistModel.Section {
        return MindsetShifterChecklistModel.Section.vision(title: services.contentService.mindsetShifterVisionTitle,
                                                           text: services.userService.myToBeVision()?.text ?? "")
    }

    var model: MindsetShifterChecklistModel {
        let sections = [header, mindsetTrigger, mindsetReactions, positiveToNegative, vision]
        let buttonText = services.contentService.mindsetShifterSaveButtonText
        return MindsetShifterChecklistModel(sections: sections, buttonTitle: buttonText)
    }

    func saveChecklist() {
    }
}
