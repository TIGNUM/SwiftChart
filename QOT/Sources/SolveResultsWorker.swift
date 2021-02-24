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
    private var solve: QDMSolve?
    private var recovery: QDMRecovery3D?
    private var selectedAnswerId: Int = 0
    private var solutionCollectionId: Int = 0
    private let resultType: ResultType

    // MARK: - Init
    init(selectedAnswerId: Int, solutionCollectionId: Int) {
        self.selectedAnswerId = selectedAnswerId
        self.solutionCollectionId = solutionCollectionId
        self.resultType = .solveDecisionTree
    }

    init(recovery: QDMRecovery3D?, resultType: ResultType) {
        self.recovery = recovery
        self.resultType = resultType
    }

    init(solve: QDMSolve?, resultType: ResultType) {
        self.solve = solve
        self.resultType = resultType
        self.solutionCollectionId = solve?.solutionCollectionId ?? 0
        self.selectedAnswerId = solve?.selectedAnswerId ?? 0
    }
}

// MARK: - Public
extension SolveResultsWorker {
    var hideShowMoreButton: Bool {
        return true
    }

    var type: ResultType {
        return resultType
    }

    func getResultViewModel(_ completion: @escaping (SolveResult, Bool) -> Void) {
        switch resultType {
        case .recoveryDecisionTree,
             .recoveryMyPlans: createRecoveryItems(completion)
        case .solveDecisionTree:
            getSolve { [weak self] (solve) in
                if solve != nil {
                    self?.solve = solve
                }
                self?.createSolveItems(completion)
            }
        case .solveDailyBrief: createSolveItems(completion)
        default: break
        }
    }

    func updateSolve(followUp: Bool) {
        if var solve = solve {
            solve.followUp = followUp
            UserService.main.updateSolve(solve) { (_, error) in
                if let error = error {
                    log("Error updateSolve: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }

    func save(followUp: Bool, _ completion: @escaping () -> Void) {
        if solve != nil {
            updateSolve(followUp: followUp)
        } else {
            createSolve(followUp: followUp)
        }
    }

    func createSolve(followUp: Bool) {
        let contentId = solutionCollectionId
        let answerId = selectedAnswerId
        relatedStrategies(contentId) { (relatedStrategies) in
            let relatedStragyIds = relatedStrategies.compactMap { $0.remoteID }
            UserService.main.createSolve(selectedAnswerId: answerId,
                                         solutionCollectionId: contentId,
                                         strategyIds: relatedStragyIds,
                                         followUp: followUp) { (_, error) in
                                            if let error = error {
                                                log("Error createSolve: \(error.localizedDescription)", level: .error)
                                            }
            }
        }
    }

    func getSolve(_ completion: @escaping (QDMSolve?) -> Void) {
        let contentId = solutionCollectionId
        let answerId = selectedAnswerId
        UserService.main.getSolves { (solves, _, error) in
            if let error = error {
                log("Error getSolves: \(error.localizedDescription)", level: .error)
            }
            let existingSolveForToday = solves?.filter({ (solve) -> Bool in
                if let createdAt = solve.createdAt, createdAt.isSameDay(Date()) {
                    return solve.selectedAnswerId == answerId && solve.solutionCollectionId == contentId
                }
                return false
            }).first
            completion(existingSolveForToday)
        }
    }

    func deleteRecovery() {
        if let recovery = recovery {
            UserService.main.deleteRecovery3D(recovery) { (error) in
                if let error = error {
                    log("Error deleteRecovery3D: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
}

// MARK: - Private
private extension SolveResultsWorker {
    func contentCollection(_ contentId: Int? = nil, _ completion: @escaping (QDMContentCollection?) -> Void) {
        ContentService.main.getContentCollectionById(contentId ?? solutionCollectionId, completion)
    }

    func relatedStrategies(_ contentId: Int? = nil, _ completion: @escaping ([QDMContentCollection]) -> Void) {
        contentCollection(contentId) { (content) in
            if let content = content {
                ContentService.main.getRelatedContentCollectionsFromContentCollection(content) { (related) in
                    completion(related ?? [])
                }
            } else {
                completion([])
            }
        }
    }

    func relatedAppLinks(_ contentId: Int? = nil, completion: @escaping( [SolveResult.Item]) -> Void ) {
        var relatedLinks: [SolveResult.Item] = []
        contentCollection(contentId) { (content) in
            content?.links.forEach { (appLink) in
                relatedLinks.append(.link(id: appLink.remoteID ?? 0, appLink: appLink, title: appLink.description ?? String.empty))
            }
            completion(relatedLinks)
        }
    }

    func relatedStrategiesContentItems(_ contentId: Int? = nil, _ completion: @escaping ([QDMContentItem]) -> Void) {
        contentCollection(contentId) { (content) in
            if let content = content {
                let relatedItems = content.relatedContentItems
                completion(relatedItems)
            }
        }
    }

    func relatedStrategyItems(_ contentId: Int? = nil, _ completion: @escaping ([SolveResult.Item]) -> Void) {
        let header: String
        switch resultType {
        case .recoveryDecisionTree,
             .recoveryMyPlans:
            header = AppTextService.get(.coach_tools_interactive_tool_3drecovery_result_section_suggested_solutions_title)
        case .solveDecisionTree,
             .solveDailyBrief:
            header = AppTextService.get(.coach_solve_result_section_strategies_title)
        default:
            header = String.empty
        }
        var relatedStrategyItems: [SolveResult.Item] = []
        relatedStrategies(contentId) { (related) in

            for (index, collection) in related.enumerated() {
                relatedStrategyItems.append(.strategy(id: collection.remoteID ?? 0,
                                                      title: collection.title,
                                                      minsToRead: collection.durationString,
                                                      hasHeader: index == 0,
                                                      headerTitle: header))
            }
            self.relatedStrategiesContentItems(contentId) { (items) in
                items.forEach {(item) in
                    relatedStrategyItems.append(.strategyContentItem(id: item.remoteID ?? 0,
                                                                     title: item.valueText,
                                                                     minsToRead: item.durationString,
                                                                     hasHeader: false,
                                                                     headerTitle: String.empty))
                }
                self.relatedAppLinks(contentId) { (relatedLinks) in
                    relatedStrategyItems.append(contentsOf: relatedLinks)
                    completion(relatedStrategyItems)
                }
            }
        }
    }

    func valueText(for tag: String, content: QDMContentCollection?) -> String? {
        return content?.contentItems.filter {
            $0.searchTagsDetailed.contains(where: { $0.name == tag }) }.first?.valueText
    }
}

// MARK: - Private Solve
private extension SolveResultsWorker {
    //TODO: Refactore -> No need to do any DB calls. The item should already have what we need.
    func createSolveItems(_ completion: @escaping (SolveResult, Bool) -> Void) {
        var items: [SolveResult.Item] = []
        let type = resultType
        solveHeader { [weak self] (headerItem) in
            self?.relatedStrategyItems { [weak self] (strategyItems) in
                self?.trigger { [weak self] (triggerItem) in
                    self?.fiveDayPlan { [weak self] (fiveDayPlanItems) in
                        self?.followUp { (followUpItem) in
                            items.append(headerItem)
                            if !strategyItems.isEmpty { items.append(contentsOf: strategyItems) }
                            if let trigger = triggerItem { items.append(trigger) }
                            if !fiveDayPlanItems.isEmpty { items.append(contentsOf: fiveDayPlanItems) }
                            items.append(followUpItem)
                            let followUp = self?.solve == nil ? true : self?.solve?.followUp == true
                            completion(SolveResult(type: type, items: items), followUp)
                        }
                    }
                }
            }
        }
    }

    func solveHeader(_ completion: @escaping (SolveResult.Item) -> Void) {
        contentCollection { [weak self] content in
            let title = self?.valueText(for: "solve-header-title", content: content) ?? String.empty
            let solution = self?.valueText(for: "solve-header-subtitle", content: content) ?? String.empty
            completion(.header(title: title, solution: solution))
        }
    }

    func trigger(_ completion: @escaping (SolveResult.Item?) -> Void) {
        contentCollection { [weak self] content in
            if let triggerType = content?.triggerType() {
                let header = self?.valueText(for: "solve-trigger-header", content: content) ?? String.empty
                let description = self?.valueText(for: "solve-trigger-description", content: content) ?? String.empty
                let buttonText = self?.valueText(for: "solve-trigger-button", content: content) ?? String.empty
                let trigger = SolveResult.Item.trigger(type: triggerType,
                                                        header: header,
                                                        description: description,
                                                        buttonText: buttonText)
                completion(trigger)
            } else {
                completion(nil)
            }
        }
    }

    func fiveDayPlan(_ completion: @escaping ([SolveResult.Item]) -> Void) {
        contentCollection { content in
            var dayPlanItems: [SolveResult.Item] = []
            let filteredContentItems = content?.contentItems
                .filter { $0.searchTagsDetailed.contains(where: { $0.name == "solve-dayplan-item" }) } ?? []
            for (index, item) in filteredContentItems.enumerated() {
                dayPlanItems.append(.fiveDayPlay(hasHeader: index == 0, text: item.valueText))
            }
            completion(dayPlanItems)
        }
    }

    func followUp(_ completion: @escaping (SolveResult.Item) -> Void) {
        contentCollection {  [weak self] content in
            let title = self?.valueText(for: "solve-follow-up-title", content: content) ?? String.empty
            let subtitle = self?.valueText(for: "solve-follow-up-subtitle", content: content) ?? String.empty
            completion(.followUp(title: title, subtitle: subtitle))
        }
    }
}

// MARK: - Private 3DRecover
private extension SolveResultsWorker {
    func createRecoveryItems(_ completion: @escaping (SolveResult, Bool) -> Void) {
        var items: [SolveResult.Item] = []
        let exclusiveItems = strategyItems(recovery?.exclusiveContentCollections ?? [],
                                           headerTitle: AppTextService.get(.coach_tools_interactive_tool_3drecovery_result_section_exclusive_content_title))
        let relatedItems = strategyItems(recovery?.suggestedSolutionsContentCollections ?? [],
                                         headerTitle: AppTextService.get(.coach_tools_interactive_tool_3drecovery_result_section_suggested_solutions_title))
        let type = resultType
        recoveryHeader { [weak self] (headerItem) in
            self?.fatigueSymptom { [weak self] (fatigueItem) in
                self?.cause { (causeItem) in
                    items.append(headerItem)
                    items.append(fatigueItem)
                    items.append(causeItem)
                    items.append(contentsOf: exclusiveItems)
                    items.append(contentsOf: relatedItems)
                    completion(SolveResult(type: type, items: items), false)
                }
            }
        }
    }

    func recoveryHeader(_ completion: @escaping (SolveResult.Item) -> Void) {
        contentCollection(resultType.contentId) { [weak self] content in
            let title = self?.valueText(for: "recovery-header-title", content: content) ?? String.empty
            let solution = self?.valueText(for: "recovery-header-subtitle", content: content) ?? String.empty
            completion(.header(title: title, solution: solution))
        }
    }

    func fatigueSymptom(_ completion: @escaping (SolveResult.Item) -> Void) {
        let contentItemId = recovery?.causeAnwser?.targetId(.contentItem) ?? 0
        ContentService.main.getContentItemById(contentItemId) { (contentItem) in
            completion(.fatigue(sympton: contentItem?.valueText ?? String.empty))
        }
    }

    func cause(_ completion: @escaping (SolveResult.Item) -> Void) {
        let contentId = recovery?.causeAnwser?.targetId(.content) ?? 0
        ContentService.main.getContentCollectionById(contentId) { [weak self] (content) in
            let cause = self?.recovery?.causeAnwser?.subtitle ?? String.empty
            let fatigueCauseExplanation = content?.contentItems.first?.valueText ?? String.empty
            completion(.cause(cause: cause, explanation: fatigueCauseExplanation))
        }
    }

    func strategyItems(_ contentCollections: [QDMContentCollection], headerTitle: String) -> [SolveResult.Item] {
        var strategyItem: [SolveResult.Item] = []
        for (index, collection) in contentCollections.enumerated() {
            strategyItem.append(.strategy(id: collection.remoteID ?? 0,
                                          title: collection.title,
                                          minsToRead: collection.durationString,
                                          hasHeader: index == 0,
                                          headerTitle: headerTitle))
        }
        return strategyItem
    }
}
