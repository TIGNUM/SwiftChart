//
//  PrepareResultsWorker.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import EventKit
import qot_dal

class PrepareResultsWorker {

    // MARK: - Properties
    typealias ListItems = [Int: [PrepareResultsType]]
    typealias ItemCompletion = ((ListItems) -> Void)
    private var items: ListItems = [:]
    private var preparation: QDMUserPreparation?
    private var level: QDMUserPreparation.Level = .LEVEL_DAILY
    weak var delegate: PrepareResultsDelegatge?
    private var currentEditKey: Prepare.Key?
    private let resultType: ResultType

    //FIXME: https://tignum.atlassian.net/browse/QOT-2688
    static let ADD_TO_CALENDAR_TITLE = "CONNECT TO CALENDAR"
    static let ADD_TO_CALENDAR_SUBTITLE = "Add this preparation to an event in your calendar to get timely reminders."

    // MARK: - Init
    init(_ contentId: Int) {
        level = .LEVEL_ON_THE_GO
        resultType = .prepareDecisionTree
        onTheGoItems(contentId) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
        }
    }

    init(_ preparation: QDMUserPreparation?, resultType: ResultType) {
        self.resultType = resultType
        self.preparation = preparation
        if let prepType = preparation?.type {
            level = prepType
            if prepType == .LEVEL_DAILY {
                self.preparation?.contentCollectionId = prepType.contentID
                generateDailyItemsAndUpdateView(self.preparation)
            } else if prepType == .LEVEL_CRITICAL {
                self.preparation?.contentCollectionId = prepType.contentID
                generateCriticalItemsAndUpdateView(self.preparation)
            }
        }
    }

    // Texts
    lazy var answerFilter: String? = {
        return preparation?.answerFilter
    }()
}

// MARK: - Getter & Setter
extension PrepareResultsWorker {
    var getResultType: ResultType {
        return resultType
    }

    var getEventType: String? {
        return preparation?.eventType
    }

    var getContentId: Int? {
        return preparation?.contentCollectionId
    }

    var feelAnswerIds: [Int] {
        get { return preparation?.feelAnswerIds ?? [] }
        set { preparation?.feelAnswerIds = newValue }
    }

    var preceiveAnswerIds: [Int] {
        get { return preparation?.preceiveAnswerIds ?? [] }
        set { preparation?.preceiveAnswerIds = newValue }
    }

    var knowAnswerIds: [Int] {
        get { return preparation?.knowAnswerIds ?? [] }
        set { preparation?.knowAnswerIds = newValue }
    }

    var benefits: String? {
        get { return preparation?.benefits }
        set { preparation?.benefits = newValue }
    }

    var strategyIds: [Int] {
        get { return preparation?.strategyIds ?? [] }
        set { preparation?.strategyIds = newValue }
    }

    var getType: QDMUserPreparation.Level {
        return level
    }

    var suggestedStrategyId: Int {
        return preparation?.relatedStrategyId ?? 0
    }

    func getSelectedIDs(_ completion: @escaping (([Int]) -> Void)) {
        var readMoreIDs = [Int]()
        getStrategyItems(strategyIds, suggestedStrategyId) { items in
            items.forEach {
                switch $0 {
                case .strategy(_, _, let readMoreID): readMoreIDs.append(readMoreID)
                default: break
                }
            }
            completion(readMoreIDs)
        }
    }

    func getRelatedStrategies(_ completion: @escaping (([QDMContentCollection]?) -> Void)) {
        strategyIDsAll(suggestedStrategyId) {
            ContentService.main.getContentCollectionsByIds($0, completion)
        }
    }

    var sectionCount: Int {
        return items.count
    }

    func rowCount(in section: Int) -> Int {
        return items[section]?.count ?? 0
    }

    func item(at indexPath: IndexPath) -> PrepareResultsType? {
        return items[indexPath.section]?[indexPath.row]
    }
}

// MARK: - Generate
private extension PrepareResultsWorker {
    func generateCriticalItemsAndUpdateView(_ prepare: QDMUserPreparation?) {
        guard let prepare = prepare else { return }
        let type = resultType
        criticalItems(prepare, prepare.answerFilter ?? "", suggestedStrategyId) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
            self?.delegate?.setupBarButtonItems(resultType: type)
        }
    }

    func generateDailyItemsAndUpdateView(_ prepare: QDMUserPreparation?) {
        guard let prepare = prepare else { return }
        let type = resultType
        dailyItems(prepare) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
            self?.delegate?.setupBarButtonItems(resultType: type)
        }
    }
}

// MARK: - Update
extension PrepareResultsWorker {
    func updateStrategies(selectedIds: [Int]) {
        strategyIds = selectedIds.isEmpty ? [-1] : selectedIds
        switch level {
        case .LEVEL_DAILY:
            generateDailyItemsAndUpdateView(preparation)
        case .LEVEL_CRITICAL:
            generateCriticalItemsAndUpdateView(preparation)
        default:
            break
        }
    }

    func updateIntentions(_ answerIds: [Int]) {
        switch currentEditKey {
        case .perceived?:
            preparation?.preceiveAnswerIds = answerIds
        case .know?:
            preparation?.knowAnswerIds = answerIds
        case .feel?:
            preparation?.feelAnswerIds = answerIds
        default:
            break
        }
        currentEditKey = nil
        generateCriticalItemsAndUpdateView(preparation)
    }

    func updateBenefits(_ benefits: String) {
        self.benefits = benefits
        generateCriticalItemsAndUpdateView(preparation)
    }

    func updateEvent(_ qdmEvent: QDMUserCalendarEvent?) {
        preparation?.eventDate = qdmEvent?.startDate
        preparation?.eventId = qdmEvent?.remoteID ?? 0
    }
}

// MARK: - Update, Delete
extension PrepareResultsWorker {
    func updatePreparation(_ completion: @escaping (QDMUserPreparation?) -> Void) {
        guard var preparation = preparation else { return }
        preparation.setReminder = preparation.eventDate != nil
        UserService.main.updateUserPreparation(preparation) { (updatedPrep, error) in
            if let error = error {
                log("Error updateUserPreparation \(error.localizedDescription)", level: .error)
            }
            completion(updatedPrep)
        }
    }

    func deletePreparation() {
        if let preparation = preparation {
            let externalIdentifier = preparation.eventExternalUniqueIdentifierId?.components(separatedBy: "[//]").first
            WorkerCalendar().deleteLocalEvent(externalIdentifier)
            UserService.main.deleteUserPreparation(preparation) { (error) in
                if let error = error {
                    log("Error deleteUserPreparation \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
}

// MARK: - DTViewModel
extension PrepareResultsWorker {
    func getDTViewModel(_ key: Prepare.Key, benefits: String?, _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void) {
        currentEditKey = key
        let answerFilter = preparation?.answerFilter ?? ""
        let selectedIds: [Int] = getSelectedIds(key: key)
        QuestionService.main.question(with: key.questionID, in: .Prepare_3_0) { (qdmQuestion) in
            guard let qdmQuestion = qdmQuestion else { return }
            let question = DTViewModel.Question(qdmQuestion: qdmQuestion)
            let filteredAnswers = qdmQuestion.answers.filter { $0.keys.contains(answerFilter) }
            let answers = filteredAnswers.compactMap { DTViewModel.Answer(qdmAnswer: $0, selectedIds: selectedIds) }
            completion(DTViewModel(question: question,
                                   answers: answers,
                                   events: [],
                                   tbvText: nil,
                                   userInputText: benefits,
                                   hasTypingAnimation: false,
                                   typingAnimationDuration: 0,
                                   previousButtonIsHidden: true,
                                   dismissButtonIsHidden: false,
                                   showNextQuestionAutomated: false),
                       qdmQuestion)
        }
    }

    func getSelectedIds(key: Prepare.Key) -> [Int] {
        switch key {
        case .feel: return feelAnswerIds
        case .know: return knowAnswerIds
        case .perceived: return preceiveAnswerIds
        default: return []
        }
    }
}
