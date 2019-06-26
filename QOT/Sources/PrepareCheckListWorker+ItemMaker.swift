//
//  PrepareCheckListWorker+ItemMaker.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension PrepareResultsWorker {
    func onTheGoItems(_ contentId: Int, completion: @escaping ItemCompletion) {
        qot_dal.ContentService.main.getContentCollectionById(contentId) { content in
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
            self?.getStrategyItems(prepare.strategyIds, self?.suggestedStrategyId) { strategyItems in
                var items = [Int: [PrepareResultsType]]()
                items[Prepare.Daily.HEADER] = self?.getGeaderItems(contentItems ?? [])
                items[Prepare.Daily.EVENT_LIST] = [.contentItem(format: .list, title: "EVENTS")]
                items[Prepare.Daily.EVENT_ITEMS] = self?.getEventItems(prepare.eventDate ?? Date(),
                                                                       title: prepare.eventTitle ?? "",
                                                                       type: prepare.eventType ?? "")
                items[Prepare.Daily.INTENTION_LIST] = [.contentItem(format: .list, title: "INTENTIONS")]
                items[Prepare.Daily.INTENTION_TITLES] = self?.getIntentionTitleItems(contentItems ?? [])
                items[Prepare.Daily.STRATEGY_LIST] = [.contentItem(format: .list, title: "SUGGESTED STRATEGIES")]
                items[Prepare.Daily.STRATEGY_ITEMS] = strategyItems
                items[Prepare.Daily.REMINDER_LIST] = [.contentItem(format: .list, title: "REMINDERS")]
                items[Prepare.Daily.REMINDER_ITEMS] = self?.getReminderItems(prepare.setICalDeepLink, prepare.setReminder)
                completion(items)
            }
        }
    }
}

extension PrepareResultsWorker {
    func criticalItems(_ prepare: QDMUserPreparation, _ answerFilter: String?, _ completion: @escaping ItemCompletion) {
        var items = [Int: [PrepareResultsType]]()
        getContentItems(prepare.contentCollectionId ?? 0) { [weak self] contentItems in
            self?.getStrategyItems(prepare.strategyIds, self?.suggestedStrategyId) { strategyItems in
                self?.getSelectedIntentionItems(prepare.preceiveAnswerIds, .perceived, completion: { (perceivedItems) in
                    self?.getSelectedIntentionItems(prepare.knowAnswerIds, .know, completion: { (knowItems) in
                        self?.getSelectedIntentionItems(prepare.feelAnswerIds, .feel, completion: { (feelItems) in
                            items[Prepare.Critical.HEADER] = self?.getGeaderItems(contentItems ?? [])
                            items[Prepare.Critical.EVENT_LIST] = [.contentItem(format: .list, title: "EVENTS")]
                            items[Prepare.Critical.EVENT_ITEMS] = self?.getEventItems(prepare.eventDate ?? Date(),
                                                                                      title: prepare.eventTitle ?? "",
                                                                                      type: prepare.eventType ?? "")
                            items[Prepare.Critical.INTENTION_LIST] = [.contentItem(format: .list, title: "INTENTIONS")]
                            items[Prepare.Critical.PERCEIVED_TITLE] = self?.getIntentionTitle(contentItems ?? [], .perceived)
                            items[Prepare.Critical.PERCEIVED_ITEMS] = perceivedItems

                            items[Prepare.Critical.KNOW_TITLE] = self?.getIntentionTitle(contentItems ?? [], .know)
                            items[Prepare.Critical.KNOW_ITEMS] = knowItems

                            items[Prepare.Critical.FEEL_TITLE] = self?.getIntentionTitle(contentItems ?? [], .feel)
                            items[Prepare.Critical.FEEL_ITEMS] = feelItems

                            items[Prepare.Critical.BENEFIT_LIST] = [.contentItem(format: .list, title: "BENEFITS")]
                            items[Prepare.Critical.BENEFIT_TITLE] = self?.getBenefitTitle(contentItems ?? [],
                                                                                          .benefits,
                                                                                          prepare.benefits)
                            items[Prepare.Critical.BENEFITS] = [.benefitItem(benefits: prepare.benefits ?? "")]

                            items[Prepare.Critical.STRATEGY_LIST] = [.contentItem(format: .list,
                                                                                  title: "SUGGESTED STRATEGIES")]
                            items[Prepare.Critical.STRATEGY_ITEMS] = strategyItems

                            items[Prepare.Critical.REMINDER_LIST] = [.contentItem(format: .list, title: "REMINDERS")]
                            items[Prepare.Critical.REMINDER_ITEMS] = self?.getReminderItems(prepare.setICalDeepLink,
                                                                                            prepare.setReminder)
                            completion(items)
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

    func generateSelectedAnswers(_ ids: [Int], _ key: Prepare.Key, _ completion: @escaping (([DecisionTreeModel.SelectedAnswer]) -> Void)) {
        qot_dal.QuestionService.main.questions(with: key.rawValue) { (questions) in
            var selectedAnswers = [DecisionTreeModel.SelectedAnswer]()
            let dqmAnswers = questions?.first?.answers.filter { ids.contains(obj: $0.remoteID ?? 0) }
            dqmAnswers?.forEach {
                selectedAnswers.append(DecisionTreeModel.SelectedAnswer(questionID: key.questionID,
                                                                        answer: Answer(qdmAnswer: $0)))
            }
            completion(selectedAnswers)
        }
    }

    func getGeaderItems(_ contentItems: [QDMContentItem]) -> [PrepareResultsType] {
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
    func getReminderItems(_ saveToICal: Bool, _ setReminder: Bool) -> [PrepareResultsType] {
        return [.reminder(title: "SET REMINDER",
                          subbtitle: "To help you remember planned events",
                          active: setReminder,
                          type: .reminder),
                .reminder(title: "SAVE TO ICAL",
                          subbtitle: "Save in your calendar events",
                          active: saveToICal,
                          type: .iCal)]
    }
}

extension PrepareResultsWorker {
    func getEventItems(_ date: Date, title: String, type: String) -> [PrepareResultsType] {
        return [.eventItem(title: title, date: date, type: type)]
    }

    func getStrategyItems(_ strategyIds: [Int],
                          _ relatedStrategyID: Int?,
                          _ completion: @escaping (([PrepareResultsType]) -> Void)) {
        if strategyIds.isEmpty == true {
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
        qot_dal.QuestionService.main.questions(with: tag.rawValue) { (questions) in
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
            qot_dal.ContentService.main.getContentCollectionById(relatedStrategyID) { content in
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
        qot_dal.ContentService.main.getContentCollectionsByIds(ids) { contentCollections in
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
            qot_dal.ContentService.main.getContentCollectionById(relatedStrategyID) { content in
                completion(content?.relatedContentIDsPrepareDefault ?? [])
            }
        } else {
            completion([])
        }
    }
}
