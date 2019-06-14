//
//  SolveResultsWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveResultsWorker {

    // MARK: - Properties

    private let services: Services
    private let selectedAnswer: Answer
    private let solveCategoryID: Int = 100082

    private var contentIDs: [Int] {
        return Array(selectedAnswer.decisions)
            .filter { $0.targetType == TargetType.content.rawValue }
            .compactMap { $0.targetID }
    }

    private var solveContentCollection: ContentCollection? {
        return Array(services.contentService.contentCollections(ids: contentIDs))
            .filter { $0.contentCategories.first?.remoteID.value == solveCategoryID }.first
    }

    private var strategiesCollections: [ContentCollection] {
        return Array(services.contentService.contentCollections(ids: contentIDs))
            .filter { $0.section == Database.Section.learnStrategy.rawValue }
    }

    // MARK: - Init

    init(services: Services, selectedAnswer: Answer) {
        self.services = services
        self.selectedAnswer = selectedAnswer
    }
}

// MARK: - SolveResultsWorkerInterface

extension SolveResultsWorker: SolveResultsWorkerInterface {

    var results: SolveResults {
        var items: [SolveResults.Item] = []
        items.append(header)
        items.append(contentsOf: strategies)
        if let trigger = trigger { items.append(trigger) }
        items.append(contentsOf: fiveDayPlan)
        items.append(followUp)
        return SolveResults(items: items)
    }

    func save(completion: () -> Void) {
        // TODO: - Save results when API is ready.
        completion()
    }
}

// MARK: - Private

private extension SolveResultsWorker {

    var header: SolveResults.Item {
        let title = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-header-title" })?.valueText ?? ""
        let solution = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-header-subtitle"})?.valueText ?? ""
        return .header(title: title, solution: solution)
    }

    var strategies: [SolveResults.Item] {
        var strategies: [SolveResults.Item] = []
        for (index, collection) in strategiesCollections.enumerated() {
            strategies.append(.strategy(id: collection.remoteID.value ?? 0,
                                        title: collection.title,
                                        minsToRead: "\(String(describing: collection.minutesToRead)) min read",
                                        hasHeader: index == 0))
        }
        return strategies
    }

    var trigger: SolveResults.Item? {
        let header = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-trigger-header" })?.valueText ?? ""
        let description = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-trigger-description" })?.valueText ?? ""
        let buttonText = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-trigger-button" })?.valueText ?? ""
        guard let triggerType = solveContentCollection?.searchTags.triggerType() else { return nil }
        return .trigger(type: triggerType, header: header, description: description, buttonText: buttonText)
    }

    var fiveDayPlan: [SolveResults.Item] {
        guard let contentItems = solveContentCollection?.contentItems else { return [] }
        var dayPlanItems: [SolveResults.Item] = []
        for (index, item) in contentItems.filter({ $0.searchTags == "solve-dayplan-item" }).enumerated() {
            dayPlanItems.append(.fiveDayPlay(hasHeader: index == 0, text: item.valueText ?? ""))
        }
        return dayPlanItems
    }

    var followUp: SolveResults.Item {
        let title = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-follow-up-title" })?.valueText ?? ""
        let subtitle = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-follow-up-subtitle" })?.valueText ?? ""
        return .followUp(title: title, subtitle: subtitle)
    }
}

fileprivate extension String {

    func triggerType() -> SolveTriggerType {
        // TODO: - Add all cases. In old Network Layer,
        // search tags from content collections are all together in a comma-separated string
        if contains("solve-trigger-mindsetshifter") {
            return .midsetShifter
        } else if contains("solve-trigger-tobevisiongenerator") {
            return .tbvGenerator
        } else {
            return .midsetShifter
        }
    }
}
