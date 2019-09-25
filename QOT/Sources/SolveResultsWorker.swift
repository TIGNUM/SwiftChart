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
    }

    // Texts
    lazy var leaveAlertTitle: String = {
        return R.string.localized.solveLeaveAlertTitle()
    }()

    lazy var leaveAlertMessage: String = {
        return R.string.localized.solveLeaveAlertMessage()
    }()

    lazy var leaveAlertLeaveButton: String = {
        return R.string.localized.solveLeaveAlertContinueButton()
    }()

    lazy var leaveAlertStayButton: String = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
    }()
}

// MARK: - Public
extension SolveResultsWorker {
    var hideShowMoreButton: Bool {
        return true
    }

    var type: ResultType {
        return resultType
    }

    func results(_ completion: @escaping (SolveResults, Bool) -> Void) {
        switch resultType {
        case .recoveryDecisionTree,
             .recoveryMyPlans: createRecoveryItems(completion)
        case .solveDecisionTree,
             .solveDailyBrief: createSolveItems(completion)
        }
    }

    func save(followUp: Bool, _ completion: @escaping () -> Void) {
        if var solve = solve {
            solve.followUp = followUp
            UserService.main.updateSolve(solve) { (_, error) in
                if let error = error {
                    log("Error updateSolve: \(error.localizedDescription)", level: .error)
                }
                completion()
            }
        } else {
            let contentId = solutionCollectionId
            let answerId = selectedAnswerId
            relatedStrategies(contentId) { (relatedStrategies) in
                let relatedStragyIds = relatedStrategies.compactMap { $0.remoteID }
                UserService.main.createSolve(selectedAnswerId: answerId,
                                             solutionCollectionId: contentId,
                                             strategyIds: relatedStragyIds,
                                             followUp: true) { (_, error) in
                                                if let error = error {
                                                    log("Error createSolve: \(error.localizedDescription)", level: .error)
                                                }
                                                completion()
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
            }
        }
    }

    func relatedStrategyItems(_ contentId: Int? = nil, _ completion: @escaping ([SolveResults.Item]) -> Void) {
        let header: String
        switch resultType {
        case .recoveryDecisionTree,
             .recoveryMyPlans:
            header = R.string.localized.headerTitleSuggestedStrategies()
        case .solveDecisionTree,
             .solveDailyBrief:
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
    //TODO: Refactore -> No need to do any DB calls. The item should already have what we need.
    func createSolveItems(_ completion: @escaping (SolveResults, Bool) -> Void) {
        var items: [SolveResults.Item] = []
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
                            completion(SolveResults(type: type, items: items), followUp)
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
            if let triggerType = content?.triggerType() {
                let header = self?.valueText(for: "solve-trigger-header", content: content) ?? ""
                let description = self?.valueText(for: "solve-trigger-description", content: content) ?? ""
                let buttonText = self?.valueText(for: "solve-trigger-button", content: content) ?? ""
                let trigger = SolveResults.Item.trigger(type: triggerType,
                                                        header: header,
                                                        description: description,
                                                        buttonText: buttonText)
                completion(trigger)
            } else {
                completion(nil)
            }
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
    func createRecoveryItems(_ completion: @escaping (SolveResults, Bool) -> Void) {
        var items: [SolveResults.Item] = []
        let exclusiveItems = strategyItems(recovery?.exclusiveContentCollections ?? [],
                                           headerTitle: R.string.localized.headerTitleExclusiveContent())
        let relatedItems = strategyItems(recovery?.suggestedSolutionsContentCollections ?? [],
                                         headerTitle: R.string.localized.headerTitleSuggestedStrategies())
        let type = resultType
        recoveryHeader { [weak self] (headerItem) in
            self?.fatigueSymptom { [weak self] (fatigueItem) in
                self?.cause { (causeItem) in
                    items.append(headerItem)
                    items.append(fatigueItem)
                    items.append(causeItem)
                    items.append(contentsOf: exclusiveItems)
                    items.append(contentsOf: relatedItems)
                    completion(SolveResults(type: type, items: items), false)
                }
            }
        }
    }

    func recoveryHeader(_ completion: @escaping (SolveResults.Item) -> Void) {
        contentCollection(resultType.contentId) { [weak self] content in
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

    func strategyItems(_ contentCollections: [QDMContentCollection], headerTitle: String) -> [SolveResults.Item] {
        var strategyItem: [SolveResults.Item] = []
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
