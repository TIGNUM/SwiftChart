//
//  SolveResultsWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SolveResultsWorker {

    // MARK: - Properties
    private let services: Services
    private let solveCategoryID: Int = 100082
    private let recoveryCategoryID: Int = 100086
    private let recoveryResultContentId: Int = 101291
    private let exclusiveContentCategoryID: Int = 100087
    private var recovery: QDMRecovery3D? = nil
    private var selectedAnswer: QDMAnswer? = nil
    private let type: ResultType

    private var contentIDs: [Int] {
        switch type {
        case .solve:
            guard let answer = selectedAnswer else { return [] }
            return Array(answer.decisions)
                .filter { $0.targetType == TargetType.content.rawValue }
                .compactMap { $0.targetTypeId }
        case .recovery: return [recoveryResultContentId]
        }
    }

    private var fatigueSymptom: String? {
        guard
            let answerId = recovery?.causeAnwserId,
            let contentItemId = services.questionsService.answer(for: answerId)?.targetId(.contentItem) else { return nil }
        return services.contentService.contentItem(id: contentItemId)?.valueText
    }

    private var fatigueCause: String? {
        return recovery?.causeAnwser?.subtitle
    }

    private var fatigueCauseExplanation: String? {
        guard
            let answerId = recovery?.causeAnwserId,
            let contentId = services.questionsService.answer(for: answerId)?.targetId(.content) else { return nil }
        return services.contentService.contentCollection(id: contentId)?.contentItems.first?.valueText
    }

    private var solveContentCollection: ContentCollection? {
        return Array(services.contentService.contentCollections(ids: contentIDs))
            .filter { $0.contentCategories.first?.remoteID.value == solveCategoryID }.first
    }

    private var recoveryContentCollection: ContentCollection? {
        return Array(services.contentService.contentCollections(ids: contentIDs))
            .filter { $0.contentCategories.first?.remoteID.value == recoveryCategoryID }.first
    }

    private var strategiesCollections: [ContentCollection] {
        guard let contentId = solveContentCollection?.remoteID.value else { return [] }
        let relatedStrategies = Array(services.contentService.contentCollection(id: contentId)?.relatedContentList
            .filter { $0.type == "RELATED_STRATEGY" } ?? [])
        let relatedIds = relatedStrategies.compactMap { $0.contentID }
        return Array(services.contentService.contentCollections(ids: relatedIds))
    }

    private var exclusiveCollections: [ContentCollection] {
        guard let recovery = recovery else { return [] }
        return Array(services.contentService.contentCollections(ids: recovery.exclusiveContentCollectionIds))
    }

    private var strategiyCollectionsRecovery: [ContentCollection] {
        guard
            let answerId = recovery?.causeAnwserId,
            let contentId = services.questionsService.answer(for: answerId)?.targetId(.content) else { return [] }
        let relatedStrategies = Array(services.contentService.contentCollection(id: contentId)?.relatedContentList.filter { $0.type == "RELATED_STRATEGY" } ?? [])
        let relatedIds = relatedStrategies.compactMap { $0.contentID }
        return Array(services.contentService.contentCollections(ids: relatedIds))
    }

    // MARK: - Init

    init(services: Services, selectedAnswer: QDMAnswer?, type: ResultType) {
        self.services = services
        self.selectedAnswer = selectedAnswer
        self.type = type
    }

    init(services: Services, recovery: QDMRecovery3D?) {
        self.services = services
        self.recovery = recovery
        self.type = .recovery
    }
}

// MARK: - SolveResultsWorkerInterface

extension SolveResultsWorker: SolveResultsWorkerInterface {
    var hideShowMoreButton: Bool {
        switch type {
        case .recovery: return true
        case .solve: return false
        }
    }

    var results: SolveResults {
        var items: [SolveResults.Item] = []
        switch type {
        case .recovery:
            items.append(recoveryHeader)
            items.append(fatigue)
            items.append(cause)
            items.append(contentsOf: exclusiveContent)
            items.append(contentsOf: strategies)
            return SolveResults(type: .recovery, items: items)
        case .solve:
            items.append(solveHeader)
            items.append(contentsOf: strategies)
            if let trigger = trigger { items.append(trigger) }
            items.append(contentsOf: fiveDayPlan)
            items.append(followUp)
            return SolveResults(type: .solve, items: items)
        }
    }

    func save(completion: @escaping () -> Void) {
        guard let solutionContentId = selectedAnswer?.decisions.filter({ $0.targetType.lowercased() == "content" }).first?.targetTypeId else {
            completion()
            return
        }
        let relatedStrategies = type == .solve ? strategiesCollections : strategiyCollectionsRecovery
        let relatedStragieIds = relatedStrategies.compactMap({ $0.remoteID.value })
        qot_dal.UserService.main.createSolve(solutionCollectionId: solutionContentId, strategyIds: relatedStragieIds, followUp: true) { (solve, error) in
            completion()
        }
    }
}

// MARK: - Private Solve

private extension SolveResultsWorker {

    var solveHeader: SolveResults.Item {
        let title = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-header-title" })?.valueText ?? ""
        let solution = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-header-subtitle" })?.valueText ?? ""
        return .header(title: title, solution: solution)
    }

    var strategies: [SolveResults.Item] {
        var strategies: [SolveResults.Item] = []
        let relatedStrategies = type == .solve ? strategiesCollections : strategiyCollectionsRecovery
        for (index, collection) in relatedStrategies.enumerated() {
            strategies.append(.strategy(id: collection.remoteID.value ?? 0,
                                        title: collection.title,
                                        minsToRead: R.string.localized.learnContentListViewMinutesLabel(String(describing: collection.minutesToRead)),
                                        hasHeader: index == 0,
                                        headerTitle: type == .solve ? R.string.localized.headerTitleStrategies() : R.string.localized.headerTitleSuggestedStrategies()))
        }
        return strategies
    }

    var trigger: SolveResults.Item? {
        guard
            let header = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-trigger-header" })?.valueText,
            let description = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-trigger-description" })?.valueText,
            let buttonText = solveContentCollection?.contentItems.first(where: { $0.searchTags == "solve-trigger-button" })?.valueText,
            let triggerType = solveContentCollection?.searchTags.triggerType() else { return nil }
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

// MARK: - Private 3DRecovery

private extension SolveResultsWorker {

    var recoveryHeader: SolveResults.Item {
        let title = recoveryContentCollection?.contentItems.first(where: { $0.searchTags == "recovery-header-title" })?.valueText ?? ""
        let solution = recoveryContentCollection?.contentItems.first(where: { $0.searchTags == "recovery-header-subtitle"})?.valueText ?? ""
        return .header(title: title, solution: solution)
    }

    var exclusiveContent: [SolveResults.Item] {
        var exclusiveContent: [SolveResults.Item] = []
        for (index, collection) in exclusiveCollections.enumerated() {
            exclusiveContent.append(.strategy(id: collection.remoteID.value ?? 0,
                                        title: collection.title,
                                        minsToRead: R.string.localized.learnContentListViewMinutesLabel(String(describing: collection.minutesToRead)),
                                        hasHeader: index == 0,
                                        headerTitle: R.string.localized.headerTitleExclusiveContent()))
        }
        return exclusiveContent
    }

    var fatigue: SolveResults.Item {
        return .fatigue(sympton: fatigueSymptom ?? "")
    }

    var cause: SolveResults.Item {
        return .cause(cause: fatigueCause ?? "", explanation: fatigueCauseExplanation ?? "")
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
