//
//  ShifterResultWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ShifterResultWorker {

    // MARK: - Properties
    private var buttonTitle = ""
    private var headerTitle = ""
    private var headerSubTitle = ""
    private var triggerTitle = ""
    private var reactionsTitle = ""
    private var lowToHighTitle = ""
    private var lowTitle = ""
    private var highTitle = ""
    private var visionTitle = ""
    private var vision = ""
    private var workerAnswerIds: [Int] = []
    private var homeAnswerIds: [Int] = []
    private var model: ShifterResult?
    private let resultItem: ShifterResult.Item
    private lazy var contentService = qot_dal.ContentService.main
    private lazy var dispatchGroup = DispatchGroup()

    // MARK: - Init
    init(_ resultItem: ShifterResult.Item) {
        self.resultItem = resultItem
    }

    // Texts
    lazy var leaveAlertTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ProfileConfirmationheader)
    }()

    lazy var leaveAlertMessage: String = {
        return ScreenTitleService.main.localizedString(for: .ProfileConfirmationdescription)
    }()

    lazy var leaveButtonTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleSaveContinue)
    }()

    lazy var cancelButtonTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
    }()
}

// MARK: - Public
extension ShifterResultWorker {
    func getModel(_ completion: @escaping (ShifterResult) -> Void) {
        setTitles()
        setVision()

        dispatchGroup.notify(queue: .main) { [unowned self] in
            let sections = [self.getHeader, self.getTrigger, self.getReactions, self.getLowToHigh, self.getVision]
            let model = ShifterResult(sections: sections, buttonTitle: self.buttonTitle)
            completion(model)
            self.model = model
        }
    }

    func createMindsetShifter() {
        qot_dal.UserService.main.createMindsetShifter(
            triggerAnswerId: resultItem.triggerAnswerId,
            toBeVisionText: vision,
            reactionsAnswerIds: resultItem.reactionsAnswerIds,
            lowPerformanceAnswerIds: resultItem.lowPerformanceAnswerIds,
            workAnswerIds: workerAnswerIds,
            homeAnswerIds: homeAnswerIds,
            highPerformanceContentItemIds: resultItem.highPerformanceContentItemIds) { (qdmMindsetShifter, error) in
                if let error = error {
                    qot_dal.log("Error createMindsetShifter: \(error.localizedDescription)", level: .error)
                }
        }
    }
}

// MARK: - Private
private extension ShifterResultWorker {
    func setTitles() {
        buttonTitle = ScreenTitleService.main.localizedString(for: .ShifterResultButtonTitle)
        headerSubTitle = ScreenTitleService.main.localizedString(for: .ShifterResultHeaderSubtitle)
        headerTitle = ScreenTitleService.main.localizedString(for: .ShifterResultHeaderTitle)
        highTitle = ScreenTitleService.main.localizedString(for: .ShifterResultHighTitle)
        lowTitle = ScreenTitleService.main.localizedString(for: .ShifterResultLowTitle)
        lowToHighTitle = ScreenTitleService.main.localizedString(for: .ShifterResultLowToHighTitle)
        reactionsTitle = ScreenTitleService.main.localizedString(for: .ShifterResultReactionsTitle)
        triggerTitle = ScreenTitleService.main.localizedString(for: .ShifterResultTriggerTitle)
        visionTitle = ScreenTitleService.main.localizedString(for: .ShifterResultVisionTitle)
    }

    func setVision() {
        dispatchGroup.enter()
        qot_dal.UserService.main.getMyToBeVision { [weak self] (vision, _, error) in
            if let error = error {
                qot_dal.log("Error while trying to getMyToBeVision: \(error.localizedDescription)", level: .error)
            }
            self?.vision = vision?.text ?? ""
            self?.dispatchGroup.leave()
        }
    }

    var getHeader: ShifterResult.Section {
        return .header(title: headerTitle, subtitle: headerSubTitle)
    }

    var getTrigger: ShifterResult.Section {
        return .trigger(title: triggerTitle, item: resultItem.trigger)
    }

    var getReactions: ShifterResult.Section {
        return .reactions(title: reactionsTitle, items: resultItem.reactions)
    }

    var getLowToHigh: ShifterResult.Section {
        return .lowToHigh(title: lowToHighTitle,
                          lowTitle: lowTitle,
                          lowItems: resultItem.lowPerformanceItems,
                          highTitle: highTitle,
                          highItems: resultItem.highPerformanceItems)
    }

    var getVision: ShifterResult.Section {
        return .vision(title: visionTitle, text: vision)
    }
}
