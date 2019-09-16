//
//  PrepareResultsWorker+ItemMaker.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension PrepareResultsWorker {
    func onTheGoItems(_ contentId: Int, completion: @escaping ItemCompletion) {
        ContentService.main.getContentCollectionById(contentId) { content in
            var checkListItems = [PrepareResultsType]()
            content?.contentItems.sorted { $0.sortOrder < $1.sortOrder }.forEach {
                checkListItems.append(.contentItem(format: $0.format, title: $0.valueText))
            }
            completion([0: checkListItems])
        }
    }
}

extension PrepareResultsWorker {
    func dailyItems(_ prepare: QDMUserPreparation, completion: @escaping ItemCompletion) {
        getContentItems(prepare.contentCollectionId ?? 0) { [weak self] contentItems in
            self?.getStrategyItems(prepare.strategyIds, prepare.relatedStrategyId) { strategyItems in
                self?.getEkEvent(completion: { ekEvent in
                    var items = [Int: [PrepareResultsType]]()
                    items[PrepareResult.Daily.HEADER] = self?.getHeaderItems(contentItems ?? [])
                    items[PrepareResult.Daily.EVENT_LIST] = [.contentItem(format: .list, title: "EVENTS")]
                    items[PrepareResult.Daily.EVENT_ITEMS] = self?.getEventItems(prepare.eventDate ?? Date(),
                                                                           title: prepare.name ?? "",
                                                                           type: prepare.eventType ?? "")
                    items[PrepareResult.Daily.INTENTION_LIST] = [.contentItem(format: .list, title: "INTENTIONS")]
                    items[PrepareResult.Daily.INTENTION_TITLES] = self?.getIntentionTitleItems(contentItems ?? [])
                    items[PrepareResult.Daily.STRATEGY_LIST] = [.contentItem(format: .list, title: "SUGGESTED STRATEGIES")]
                    items[PrepareResult.Daily.STRATEGY_ITEMS] = strategyItems
                    items[PrepareResult.Daily.REMINDER_LIST] = [.contentItem(format: .list, title: "REMINDERS")]
                    items[PrepareResult.Daily.REMINDER_ITEMS] = self?.getReminderItems(prepare.setICalDeepLink,
                                                                                 prepare.setReminder,
                                                                                 ekEvent: ekEvent)
                    completion(items)
                })
            }
        }
    }
}

extension PrepareResultsWorker {
    func criticalItems(_ prepare: QDMUserPreparation,
                       _ answerFilter: String?,
                       _ suggestedStrategyId: Int?,
                       _ completion: @escaping ItemCompletion) {
        var items = [Int: [PrepareResultsType]]()
        getContentItems(prepare.contentCollectionId ?? 0) { [weak self] contentItems in
            self?.getStrategyItems(prepare.strategyIds, suggestedStrategyId) {  [weak self] strategyItems in
                self?.getSelectedIntentionItems(prepare.preceiveAnswerIds, .perceived, completion: {  [weak self] (perceivedItems) in
                    self?.getSelectedIntentionItems(prepare.knowAnswerIds, .know, completion: {  [weak self] (knowItems) in
                        self?.getSelectedIntentionItems(prepare.feelAnswerIds, .feel, completion: {  [weak self] (feelItems) in
                            self?.getEkEvent(completion: {  [weak self] ekEvent in
                                items[PrepareResult.Critical.HEADER] = self?.getHeaderItems(contentItems ?? [])
                                items[PrepareResult.Critical.EVENT_LIST] = [.contentItem(format: .list, title: "EVENTS")]
                                items[PrepareResult.Critical.EVENT_ITEMS] = self?.getEventItems(prepare.eventDate ?? Date(),
                                                                                          title: prepare.name ?? "",
                                                                                          type: prepare.eventType ?? "")
                                items[PrepareResult.Critical.INTENTION_LIST] = [.contentItem(format: .list, title: "INTENTIONS")]
                                items[PrepareResult.Critical.PERCEIVED_TITLE] = self?.getIntentionTitle(contentItems ?? [], .perceived)
                                items[PrepareResult.Critical.PERCEIVED_ITEMS] = perceivedItems

                                items[PrepareResult.Critical.KNOW_TITLE] = self?.getIntentionTitle(contentItems ?? [], .know)
                                items[PrepareResult.Critical.KNOW_ITEMS] = knowItems

                                items[PrepareResult.Critical.FEEL_TITLE] = self?.getIntentionTitle(contentItems ?? [], .feel)
                                items[PrepareResult.Critical.FEEL_ITEMS] = feelItems

                                items[PrepareResult.Critical.BENEFIT_LIST] = [.contentItem(format: .list, title: "BENEFITS")]
                                items[PrepareResult.Critical.BENEFIT_TITLE] = self?.getBenefitTitle(contentItems ?? [],
                                                                                              .benefits,
                                                                                              prepare.benefits)
                                items[PrepareResult.Critical.BENEFITS] = [.benefitItem(benefits: prepare.benefits ?? "")]

                                items[PrepareResult.Critical.STRATEGY_LIST] = [.contentItem(format: .list,
                                                                                      title: "SUGGESTED STRATEGIES")]
                                items[PrepareResult.Critical.STRATEGY_ITEMS] = strategyItems

                                items[PrepareResult.Critical.REMINDER_LIST] = [.contentItem(format: .list, title: "REMINDERS")]
                                items[PrepareResult.Critical.REMINDER_ITEMS] = self?.getReminderItems(prepare.setICalDeepLink,
                                                                                             prepare.setReminder,
                                                                                             ekEvent: ekEvent)
                                completion(items)
                            })
                        })
                    })
                })
            }
        }
    }
}

extension PrepareResultsWorker {
    func getContentItems(_ contentId: Int, completion: @escaping (([QDMContentItem]?) -> Void)) {
        qot_dal.ContentService.main.getContentCollectionById(contentId) { content in
            completion(content?.contentItems.sorted { $0.sortOrder < $1.sortOrder })
        }
    }

    func generateSelectedAnswers(_ ids: [Int],
                                 _ key: Prepare.Key,
                                 _ completion: @escaping (([SelectedAnswer]) -> Void)) {
        QuestionService.main.questions(with: key.rawValue) { (questions) in
            let question = DTViewModel.Question(remoteId: questions?.first?.remoteID ?? 0,
                                                title: questions?.first?.title ?? "",
                                                key: questions?.first?.key ?? "",
                                                answerType: .multiSelection,
                                                duration: 0,
                                                maxSelections: questions?.first?.maxPossibleSelections ?? 0)
            let qdmAnswers = questions?.first?.answers.filter { ids.contains(obj: $0.remoteID ?? 0) }
            let answers = qdmAnswers?.compactMap { DTViewModel.Answer(qdmAnswer: $0) } ?? []
            let selectedAnswers: [SelectedAnswer] = [SelectedAnswer(question: question, answers: answers)]
            completion(selectedAnswers)
        }
    }

    func getHeaderItems(_ contentItems: [QDMContentItem]) -> [PrepareResultsType] {
        var items = [PrepareResultsType]()
        contentItems.filter { $0.format.isHeader }.forEach {
            items.append(.contentItem(format: $0.format, title: $0.valueText))
        }
        return items
    }

    func getIntentionTitleItems(_ contentItems: [QDMContentItem]) -> [PrepareResultsType] {
        var items = [PrepareResultsType]()
        contentItems.filter { $0.format.isTitle }.forEach {
            items.append(.contentItem(format: $0.format, title: $0.valueText))
        }
        return items
    }

    func getIntentionTitle(_ contentItems: [QDMContentItem], _ key: Prepare.Key) -> [PrepareResultsType] {
        var items = [PrepareResultsType]()
        contentItems.filter { $0.format.isTitle && $0.valueText.contains(key.tag) }.forEach {
            items.append(.intentionContentItem(format: $0.format, title: $0.valueText, key: key))
        }
        return items
    }

    func getBenefitTitle(_ contentItems: [QDMContentItem],
                         _ key: Prepare.Key,
                         _ benefits: String?) -> [PrepareResultsType] {
        var items = [PrepareResultsType]()
        contentItems.filter { $0.format.isTitle && $0.valueText.contains(key.tag) }.forEach {
            items.append(.benefitContentItem(format: $0.format,
                                             title: $0.valueText,
                                             benefits: benefits,
                                             questionID: key.questionID))
        }
        return items
    }

    //TODO: no hardcoded strings
    func getReminderItems(_ saveToICal: Bool, _ setReminder: Bool, ekEvent: EKEvent?) -> [PrepareResultsType] {
        let setReminderItem = PrepareResultsType.reminder(title: "SET REMINDER",
                                                          subbtitle: "To help you remember planned events",
                                                          active: setReminder,
                                                          type: .reminder)
        let saveToIcalItem = PrepareResultsType.reminder(title: "SAVE TO ICAL",
                                                         subbtitle: "Save in your calendar events",
                                                         active: saveToICal,
                                                         type: .iCal)
        if ekEvent != nil {
            return [setReminderItem, saveToIcalItem]
        }
        return [setReminderItem]
    }
}

extension PrepareResultsWorker {
    func getEventItems(_ date: Date, title: String, type: String) -> [PrepareResultsType] {
        return [.eventItem(title: title, date: date, type: type)]
    }

    func getStrategyItems(_ strategyIds: [Int],
                          _ relatedStrategyID: Int?,
                          _ completion: @escaping (([PrepareResultsType]) -> Void)) {
        if strategyIds.count == 1 && strategyIds.first == -1 {
            // TODO: Remove the hack?: If users removes all strategies == [-1] distinguish new created empty prepare.
            completion([])
        } else if strategyIds.isEmpty == true && relatedStrategyID == nil {
            makeStrategyItems(strategyIds, completion)
        } else if strategyIds.isEmpty == true && relatedStrategyID != nil {
            strategyIDsDefault(relatedStrategyID) { [weak self] relatedIDs in
                self?.makeStrategyItems(relatedIDs, completion)
            }
        } else {
            makeStrategyItems(strategyIds, completion)
        }
    }

    func getSelectedIntentionItems(_ answersIds: [Int],
                                   _ tag: Prepare.Key,
                                   completion: @escaping (([PrepareResultsType]) -> Void)) {
        var items = [PrepareResultsType]()
        QuestionService.main.questions(with: tag.rawValue) { (questions) in
            questions?.first?.answers.filter { answersIds.contains($0.remoteID ?? 0) }.forEach {
                items.append(.intentionItem(title: $0.subtitle   ?? ""))
            }
            completion(items)
        }
    }

    func filteredAnswers(_ tag: Prepare.Key,
                         _ answers: [DecisionTreeModel.SelectedAnswer]) -> [DecisionTreeModel.SelectedAnswer] {
        return answers.filter { $0.questionID == tag.questionID }
    }

    func strategyIDsAll(_ relatedStrategyID: Int?, _ completion: @escaping (([Int]) -> Void)) {
        if let relatedStrategyID = relatedStrategyID {
            ContentService.main.getContentCollectionById(relatedStrategyID) { content in
                completion(content?.relatedContentIDsPrepareAll ?? [])
            }
        } else {
            completion([])
        }
    }
}

private extension PrepareResultsWorker {
    func makeStrategyItems(_ ids: [Int], _ completion: @escaping (([PrepareResultsType]) -> Void)) {
        var items = [PrepareResultsType]()
        ContentService.main.getContentCollectionsByIds(ids) { contentCollections in
            contentCollections?.forEach {
                items.append(.strategy(title: $0.title,
                                       durationString: $0.durationString,
                                       readMoreID: $0.remoteID ?? 0))
            }
            completion(items)
        }
    }

    func strategyIDsDefault(_ relatedStrategyID: Int?, _ completion: @escaping (([Int]) -> Void)) {
        if let relatedStrategyID = relatedStrategyID {
            ContentService.main.getContentCollectionById(relatedStrategyID) { content in
                completion(content?.relatedContentIDsPrepareDefault ?? [])
            }
        } else {
            completion([])
        }
    }
}
