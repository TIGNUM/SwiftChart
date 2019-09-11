//
//  DTMindsetWorker.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTMindsetWorker: DTWorker {}

// MARK: - MindsetShifter
extension DTMindsetWorker {
    func getMindsetShifter(tbv: QDMToBeVision?,
                           selectedAnswers: [SelectedAnswer],
                           completion: @escaping (QDMMindsetShifter?) -> Void) {
        var tempAnswers: [DTViewModel.Answer] = []
        selectedAnswers.forEach { (_, answers) in
            tempAnswers.append(contentsOf: answers)
        }

        getMindsetResultItem(answers: tempAnswers, tbv: tbv) { [weak self] (mindsetItem) in
            self?.createMindsetShifter(mindsetItem: mindsetItem, completion: completion)
        }
    }
}

private extension DTMindsetWorker {
    func createMindsetShifter(mindsetItem: MindsetResult.Item, completion: @escaping (QDMMindsetShifter?) -> Void) {
        userService.createMindsetShifter(triggerAnswerId: mindsetItem.triggerAnswerId,
                                         toBeVisionText: mindsetItem.toBeVisionText,
                                         reactionsAnswerIds: mindsetItem.reactionsAnswerIds,
                                         lowPerformanceAnswerIds: mindsetItem.lowPerformanceAnswerIds,
                                         workAnswerIds: mindsetItem.workAnswerIds,
                                         homeAnswerIds: mindsetItem.homeAnswerIds,
                                         highPerformanceContentItemIds: mindsetItem.highPerformanceContentItemIds) {
                                            (mindsetShifter, error) in
                                            if let error = error {
                                                log("Error createMindsetShifter: \(error)", level: .error)
                                            }
                                            completion(mindsetShifter)

        }
    }

    func getMindsetResultItem(answers: [DTViewModel.Answer],
                              tbv: QDMToBeVision?,
                              completion: @escaping (MindsetResult.Item) -> Void) {
        let dispatchGroup = DispatchGroup()
        let triggerAnswers = filteredAnswers([answers[0]], filter: Mindset.Filter.Trigger)
        let reactionAnswers = filteredAnswers(answers, filter: Mindset.Filter.Reaction)
        let lowAnswers = filteredAnswers(answers, filter: Mindset.Filter.LowPerfomance)
        var highPerformanceContentItemIds: [QDMContentItem] = []
        let contentItemIds = answers.compactMap { $0.targetId(.contentItem) }

        dispatchGroup.enter()
        getHighPerformanceContentItemIds(contentItemIds) { (items) in
            highPerformanceContentItemIds = items
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            let resultItem = MindsetResult.Item(triggerAnswerId: triggerAnswers.map { $0.remoteId }.first ?? 0,
                                                toBeVisionText: tbv?.text,
                                                reactionsAnswerIds: reactionAnswers.map { $0.remoteId },
                                                lowPerformanceAnswerIds: lowAnswers.map { $0.remoteId },
                                                workAnswerIds: [],
                                                homeAnswerIds: [],
                                                highPerformanceContentItemIds: [])
            completion(resultItem)
        }
    }

    func filteredAnswers(_ answers: [DTViewModel.Answer], filter: String) -> [DTViewModel.Answer] {
        return answers.filter { $0.keys.filter { $0.contains(filter) }.isEmpty == false }
    }

    func getHighPerformanceContentItemIds(_ contentItemIDs: [Int], completion: @escaping ([QDMContentItem]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var items: [QDMContentItem] = []
        contentItemIDs.forEach {
            dispatchGroup.enter()
            contentService.getContentItemById($0) { (item) in
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
