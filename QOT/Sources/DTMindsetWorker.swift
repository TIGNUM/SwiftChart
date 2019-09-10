//
//  DTMindsetWorker.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTMindsetWorker: DTWorker {
    
}

// MARK: - MindsetShifter
extension DTMindsetWorker {
    func getShifterResultItem(answers: [DTViewModel.Answer],
                              completion: @escaping (ShifterResult.Item) -> Void) {
        let dispatchGroup = DispatchGroup()
        let triggerAnswers = filteredAnswers([answers[0]], filter: .Trigger)
        let reactionAnswers = filteredAnswers(answers, filter: .Reaction)
        let lowAnswers = filteredAnswers(answers, filter: .LowPerfomance)
        var highItems: [QDMContentItem] = []
        let contentItemIds = answers.compactMap { $0.targetId(.contentItem) }

        dispatchGroup.enter()
        getHighItems(contentItemIds) { (items) in
            highItems = items
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            let resultItem = ShifterResult.Item(triggerAnswerId: triggerAnswers.map { $0.remoteId }.first ?? 0,
                                                reactionsAnswerIds: reactionAnswers.map { $0.remoteId },
                                                lowPerformanceAnswerIds: lowAnswers.map { $0.remoteId },
                                                highPerformanceContentItemIds: contentItemIds,
                                                trigger: triggerAnswers.map { $0.title }.first ?? "",
                                                reactions: reactionAnswers.map { $0.title },
                                                lowPerformanceItems: lowAnswers.map { $0.title },
                                                highPerformanceItems: highItems.map { $0.valueText })
            completion(resultItem)
        }
    }

    func filteredAnswers(_ answers: [DTViewModel.Answer], filter: DecisionTreeModel.Filter) -> [DTViewModel.Answer] {
        return answers.filter { $0.keys.filter { $0.contains(filter) }.isEmpty == false }
    }

    func getHighItems(_ contentItemIDs: [Int], completion: @escaping ([QDMContentItem]) -> Void) {
        var items: [QDMContentItem] = []
        let dispatchGroup = DispatchGroup()
        contentItemIDs.forEach {
            dispatchGroup.enter()
            qot_dal.ContentService.main.getContentItemById($0) { (item) in
                if let item = item, item.searchTags.contains("mindsetshifter-highperformance-item") {
                    items.append(item)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(items)
        }
    }
}
