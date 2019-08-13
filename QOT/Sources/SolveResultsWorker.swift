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
    private var recovery: QDMRecovery3D? = nil
    private var selectedAnswer: QDMAnswer? = nil
    private let type: ResultType

    // MARK: - Init
    init(selectedAnswer: QDMAnswer?, type: ResultType) {
        self.selectedAnswer = selectedAnswer
        self.type = type
    }

    init(recovery: QDMRecovery3D?) {
        self.recovery = recovery
        self.type = .recovery
    }
}

// MARK: - Public
extension SolveResultsWorker {
    var hideShowMoreButton: Bool {
        return type == .recovery
    }

    var confirmationKind: Confirmation.Kind {
        return type.confirmationKind
    }

    var resultType: ResultType {
        return type
    }

    func results(_ completion: @escaping (SolveResults) -> Void) {
        switch type {
        case .recovery:
            createRecoveryItems(completion)
        case .solve:
            createSolveItems(completion)
        }
    }

    func save(_ completion: @escaping () -> Void) {
        let contentId = recovery?.fatigueAnswer?.targetId(.content)
        relatedStrategies(contentId) { [weak self] (relatedStrategies) in
            let relatedStragyIds = relatedStrategies.compactMap { $0.remoteID }
            qot_dal.UserService.main.createSolve(selectedAnswerId: self?.selectedAnswer?.remoteID ?? 0,
                                                 solutionCollectionId: self?.selectedAnswer?.targetId(.content) ?? 0,
                                                 strategyIds: relatedStragyIds,
                                                 followUp: true) { (solve, error) in
                                                    completion()
            }
        }
    }

    func deleteModel() {
        switch type {
        case .recovery:
            guard let recovery = recovery else { return }
            qot_dal.UserService.main.deleteRecovery3D(recovery) { error in
                if let error = error {
                    qot_dal.log("Error while trying to delete recovery: \(error.localizedDescription)", level: .debug)
                }
            }
        case .solve:
            return
        }
    }
}

// MARK: - Private
private extension SolveResultsWorker {
    func contentCollection(_ contentId: Int? = nil, _ completion: @escaping (QDMContentCollection?) -> Void) {
        let targetContentId = selectedAnswer?.targetId(.content) ?? 0
        qot_dal.ContentService.main.getContentCollectionById(contentId ?? targetContentId, completion)
    }

    func relatedStrategies(_ contentId: Int? = nil, _ completion: @escaping ([QDMContentCollection]) -> Void) {
        contentCollection(contentId) { (content) in
            if let content = content {
                qot_dal.ContentService.main.getRelatedContentCollectionsFromContentCollection(content) { (related) in
                    completion(related ?? [])
                }
            }
        }
    }

    func relatedStrategyItems(_ contentId: Int? = nil, _ completion: @escaping ([SolveResults.Item]) -> Void) {
        let header: String
        switch type {
        case .recovery:
            header = R.string.localized.headerTitleSuggestedStrategies()
        case .solve:
            header = R.string.localized.headerTitleStrategies()
        }
        relatedStrategies(contentId) { (related) in
            var relatedStrategyItems: [SolveResults.Item] = []
            for (index, collection) in related.enumerated() {
                relatedStrategyItems.append(.strategy(id: collection.remoteID ?? 0,
                                                      title: collection.title,
                                                      minsToRead: collection.durationString,
                                                      hasHeader: index == 0,
                                                      headerTitle: header))
            }
            completion(relatedStrategyItems)
        }
    }

    func valueText(for tag: String, content: QDMContentCollection?) -> String? {
        return content?.contentItems.filter {
            $0.searchTagsDetailed.contains(where: { $0.name == tag }) }.first?.valueText
    }
}

// MARK: - Private Solve
private extension SolveResultsWorker {
    func createSolveItems(_ completion: @escaping (SolveResults) -> Void) {
        var items: [SolveResults.Item] = []
        solveHeader { [weak self] (headerItem) in
            self?.relatedStrategyItems { (strategyItems) in
                self?.trigger { (triggerItem) in
                    self?.fiveDayPlan { (fiveDayPlanItems) in
                        self?.followUp { (followUpItem) in
                            items.append(headerItem)
                            items.append(contentsOf: strategyItems)
                            if let trigger = triggerItem { items.append(trigger) }
                            items.append(contentsOf: fiveDayPlanItems)
                            items.append(followUpItem)
                            completion(SolveResults(type: .solve, items: items))
                        }
                    }
                }
            }
        }
    }

    func solveHeader(_ completion: @escaping (SolveResults.Item) -> Void) {
        contentCollection { [weak self] content in
            let title = self?.valueText(for: "solve-header-title", content: content) ?? ""
            let solution = self?.valueText(for: "solve-header-subtitle", content: content) ?? ""
            completion(.header(title: title, solution: solution))
        }
    }

    func trigger(_ completion: @escaping (SolveResults.Item?) -> Void) {
        contentCollection { [weak self] content in
            let header = self?.valueText(for: "solve-trigger-header", content: content) ?? ""
            let description = self?.valueText(for: "solve-trigger-description", content: content) ?? ""
            let buttonText = self?.valueText(for: "solve-trigger-button", content: content) ?? ""
            let triggerType = content?.triggerType()
            let trigger = SolveResults.Item.trigger(type: triggerType,
                                                    header: header,
                                                    description: description,
                                                    buttonText: buttonText)
            completion(trigger)
        }
    }

    func fiveDayPlan(_ completion: @escaping ([SolveResults.Item]) -> Void) {
        contentCollection { content in
            var dayPlanItems: [SolveResults.Item] = []
            let filteredContentItems = content?.contentItems
                .filter { $0.searchTagsDetailed.contains(where: { $0.name == "solve-dayplan-item" }) } ?? []
            for (index, item) in filteredContentItems.enumerated() {
                dayPlanItems.append(.fiveDayPlay(hasHeader: index == 0, text: item.valueText))
            }
            completion(dayPlanItems)
        }
    }

    func followUp(_ completion: @escaping (SolveResults.Item) -> Void) {
        contentCollection {  [weak self] content in
            let title = self?.valueText(for: "solve-follow-up-title", content: content) ?? ""
            let subtitle = self?.valueText(for: "solve-follow-up-subtitle", content: content) ?? ""
            completion(.followUp(title: title, subtitle: subtitle))
        }
    }
}

// MARK: - Private 3DRecover
private extension SolveResultsWorker {
    func createRecoveryItems(_ completion: @escaping (SolveResults) -> Void) {
        var items: [SolveResults.Item] = []
        recoveryHeader { [weak self] (headerItem) in
            self?.fatigueSymptom { (fatigueItem) in
                self?.cause { (causeItem) in
                    self?.exclusiveContent { (exclusiveItems) in
                        let contentId = self?.recovery?.causeAnwser?.targetId(.content)
                        self?.relatedStrategyItems(contentId) { (strategyItems) in
                            items.append(headerItem)
                            items.append(fatigueItem)
                            items.append(causeItem)
                            items.append(contentsOf: exclusiveItems)
                            items.append(contentsOf: strategyItems)
                            completion(SolveResults(type: .recovery, items: items))
                        }
                    }
                }
            }
        }
    }

    func recoveryHeader(_ completion: @escaping (SolveResults.Item) -> Void) {
        contentCollection(type.contentId) { [weak self] content in
            let title = self?.valueText(for: "recovery-header-title", content: content) ?? ""
            let solution = self?.valueText(for: "recovery-header-subtitle", content: content) ?? ""
            completion(.header(title: title, solution: solution))
        }
    }

    func fatigueSymptom(_ completion: @escaping (SolveResults.Item) -> Void) {
        let contentItemId = recovery?.causeAnwser?.targetId(.contentItem) ?? 0
        qot_dal.ContentService.main.getContentItemById(contentItemId) { (contentItem) in
            completion(.fatigue(sympton: contentItem?.valueText ?? ""))
        }
    }

    func cause(_ completion: @escaping (SolveResults.Item) -> Void) {
        let contentId = recovery?.causeAnwser?.targetId(.content) ?? 0
        qot_dal.ContentService.main.getContentCollectionById(contentId) { [weak self] (content) in
            let cause = self?.recovery?.causeAnwser?.subtitle ?? ""
            let fatigueCauseExplanation = content?.contentItems.first?.valueText ?? ""
            completion(.cause(cause: cause, explanation: fatigueCauseExplanation))
        }
    }

    func exclusiveContent(_ completion: @escaping ([SolveResults.Item]) -> Void) {
        let ids = recovery?.exclusiveContentCollectionIds ?? []
        var exclusiveContent: [SolveResults.Item] = []
        qot_dal.ContentService.main.getContentCollectionsByIds(ids) { (exclusiveCollections) in
            if let exclusiveCollections = exclusiveCollections {
                for (index, collection) in exclusiveCollections.enumerated() {
                    exclusiveContent.append(.strategy(id: collection.remoteID ?? 0,
                                                      title: collection.title,
                                                      minsToRead: collection.durationString,
                                                      hasHeader: index == 0,
                                                      headerTitle: R.string.localized.headerTitleExclusiveContent()))
                }
                completion(exclusiveContent)
            } else {
                completion([])
            }
        }
    }
}
