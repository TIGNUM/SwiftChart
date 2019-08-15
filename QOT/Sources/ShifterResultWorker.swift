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
}

// MARK: - Public
extension ShifterResultWorker {
    func getModel(_ completion: @escaping (ShifterResult) -> Void) {
        ShifterResult.Tag.allCases.forEach { setTitle($0) }
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
    func setTitle(_ tag: ShifterResult.Tag) {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(tag.predicate) { [weak self] (contentItem) in
            let title = contentItem?.valueText ?? ""
            switch tag {
            case .buttonTitle:
                self?.buttonTitle = title
            case .headerSubtitle:
                self?.headerSubTitle = title
            case .headerTitle:
                self?.headerTitle = title
            case .highTitle:
                self?.highTitle = title
            case .lowTitle:
                self?.lowTitle = title
            case .lowToHighTitle:
                self?.lowToHighTitle = title
            case .reactionsTitle:
                self?.reactionsTitle = title
            case .triggerTitle:
                self?.triggerTitle = title
            case .visionTitle:
                self?.visionTitle = title
            }
            self?.dispatchGroup.leave()
        }
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
