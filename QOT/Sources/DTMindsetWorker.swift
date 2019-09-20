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
        getMindsetShifterItems(selectedAnswers: selectedAnswers, tbv: tbv) { [weak self] (mindsetItem) in
            self?.createMindsetShifter(mindsetItem: mindsetItem, completion: completion)
        }
    }
}

private extension DTMindsetWorker {
    func createMindsetShifter(mindsetItem: MindsetResult.Item, completion: @escaping (QDMMindsetShifter?) -> Void) {
        UserService.main.createMindsetShifter(triggerAnswerId: mindsetItem.triggerAnswerId,
                                              toBeVisionText: mindsetItem.toBeVisionText,
                                              reactionsAnswerIds: mindsetItem.reactionsAnswerIds,
                                              lowPerformanceAnswerIds: mindsetItem.lowPerformanceAnswerIds,
                                              workAnswerIds: [],
                                              homeAnswerIds: [],
                                              highPerformanceContentItemIds: mindsetItem.highPerformanceContentItemIds) { (mindsetShifter, error) in
                                                if let error = error {
                                                    log("Error createMindsetShifter: \(error)", level: .error)
                                                }
                                                completion(mindsetShifter)
        }
    }

    func getMindsetShifterItems(selectedAnswers: [SelectedAnswer],
                                tbv: QDMToBeVision?,
                                completion: @escaping (MindsetResult.Item) -> Void) {
        let answers = selectedAnswers.flatMap { $0.answers }
        let triggerAnswer = selectedAnswers.filter { $0.question?.key == Mindset.QuestionKey.MoreInfo }.first
        let reactionAnswers = filteredAnswers(answers, filter: Mindset.Filter.Reaction)
        let lowAnswers = filteredAnswers(answers, filter: Mindset.Filter.LowPerfomance)
        let lowAnswersContentIDs = lowAnswers.compactMap { $0.targetId(.content) }

        ContentService.main.getContentCollectionsByIds(lowAnswersContentIDs) { (contentCollections) in
            let highContentItemIds = contentCollections?.flatMap { $0.contentItems }.map { $0.remoteID ?? 0 } ?? []
            let resultItem = MindsetResult.Item(triggerAnswerId: triggerAnswer?.answers.first?.remoteId,
                                                toBeVisionText: tbv?.text,
                                                reactionsAnswerIds: reactionAnswers.map { $0.remoteId },
                                                lowPerformanceAnswerIds: lowAnswers.map { $0.remoteId },
                                                highPerformanceContentItemIds: highContentItemIds)
            completion(resultItem)
        }
    }

    func filteredAnswers(_ answers: [DTViewModel.Answer], filter: String) -> [DTViewModel.Answer] {
        return answers.filter { $0.keys.filter { $0.contains(filter) }.isEmpty == false }
    }
}
