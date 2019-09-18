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

final class PrepareResultsWorker {

    // MARK: - Properties
    typealias ListItems = [Int: [PrepareResultsType]]
    typealias ItemCompletion = ((ListItems) -> Void)
    private var items: ListItems = [:]
    private var preparation: QDMUserPreparation?
    private var canDelete: Bool = false
    private var level: QDMUserPreparation.Level = .LEVEL_DAILY
    weak var delegate: PrepareResultsDelegatge?
    var dataModified: Bool = false
    private var currentEditKey: Prepare.Key?

    // MARK: - Init
    init(_ contentId: Int) {
        level = .LEVEL_ON_THE_GO
        onTheGoItems(contentId) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
        }
    }

    init(_ preparation: QDMUserPreparation?, canDelete: Bool) {
        self.canDelete = canDelete
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
    lazy var leaveAlertTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ProfileConfirmationheader)
    }()

    lazy var leaveAlertMessage: String = {
        return ScreenTitleService.main.localizedString(for: .ProfileConfirmationdescription)
    }()

    lazy var leaveButtonTitle: String = {
        return ScreenTitleService.main.localizedString(for: .MySprintDetailsNotesButtonLeave)
    }()

    lazy var cancelButtonTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
    }()

    lazy var answerFilter: String? = {
        return preparation?.answerFilter
    }()
}

// MARK: - Getter & Setter
extension PrepareResultsWorker {
    var getEventType: String? {
        return preparation?.eventType
    }

    var getContentId: Int? {
        return preparation?.contentCollectionId
    }

    var feelAnswerIds: [Int] {
        get { return preparation?.feelAnswerIds ?? [] }
        set {
            dataModified = true
            preparation?.feelAnswerIds = newValue

        }
    }

    var preceiveAnswerIds: [Int] {
        get { return preparation?.preceiveAnswerIds ?? [] }
        set {
            preparation?.preceiveAnswerIds = newValue
        }
    }

    var knowAnswerIds: [Int] {
        get { return preparation?.knowAnswerIds ?? [] }
        set {
            dataModified = true
            preparation?.knowAnswerIds = newValue
        }
    }

    var benefits: String? {
        get { return preparation?.benefits }
        set {
            dataModified = true
            preparation?.benefits = newValue
        }
    }

    var strategyIds: [Int] {
        get { return preparation?.strategyIds ?? [] }
        set {
            dataModified = true
            preparation?.strategyIds = newValue
        }
    }

    var getType: QDMUserPreparation.Level {
        return level
    }

    var suggestedStrategyId: Int {
        return preparation?.relatedStrategyId ?? 0
    }

    var saveToICal: Bool {
        get { return preparation?.setICalDeepLink ?? false }
        set {
            dataModified = true
            preparation?.setICalDeepLink = newValue
            updateCalendarEventLink(isOn: newValue)
        }
    }

    var setReminder: Bool {
        get { return preparation?.setReminder ?? false }
        set {
            dataModified = true
            preparation?.setReminder = newValue
        }
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
            qot_dal.ContentService.main.getContentCollectionsByIds($0, completion)
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

    func getEkEvent(completion: @escaping (EKEvent?) -> Void) {
        CalendarService.main.getCalendarEvents { [weak self] (events, initiated, error) in
            let selectedEvent = events?.filter { $0.qotId == self?.preparation?.eventQotId ?? "" }.first
            if let event = selectedEvent {
                completion(EKEventStore.shared.event(with: event))
            } else {
                completion(nil)
            }
        }
    }
}

// MARK: - Generate
private extension PrepareResultsWorker {
    func updateCalendarEventLink(isOn: Bool) {
        getEkEvent { [weak self] (ekEvent) in
            if isOn == true, let permissionsManager = AppCoordinator.permissionsManager {
                permissionsManager.askPermission(for: [.calendar], completion: { [weak self] status in
                    guard let status = status[.calendar] else { return }
                    switch status {
                    case .granted:
                        ekEvent?.addPreparationLink(preparationID: self?.preparation?.qotId ?? "")
                    case .later:
                        permissionsManager.updateAskStatus(.canAsk, for: .calendar)
                    default:
                        break
                    }
                })
                ekEvent?.addPreparationLink(preparationID: self?.preparation?.qotId ?? "")
            } else {
                do {
                    try ekEvent?.removePreparationLink()
                } catch {
                    qot_dal.log("Error while trying to remove link from event: \(error.localizedDescription)",
                        level: .error)
                }
            }
        }
    }

    func updateAnswerIds(_ answers: [DecisionTreeModel.SelectedAnswer],
                         _ completion: @escaping (QDMUserPreparation?) -> Void) {
        preceiveAnswerIds = filteredAnswers(.perceived, answers).compactMap { $0.answer.remoteID }
        knowAnswerIds = filteredAnswers(.know, answers).compactMap { $0.answer.remoteID }
        feelAnswerIds = filteredAnswers(.feel, answers).compactMap { $0.answer.remoteID }
        updatePreparation(completion)
    }

    func generateCriticalItemsAndUpdateView(_ prepare: QDMUserPreparation?) {
        guard let prepare = prepare else { return }
        criticalItems(prepare, prepare.answerFilter ?? "", suggestedStrategyId) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
        }
    }

    func generateDailyItemsAndUpdateView(_ prepare: QDMUserPreparation?) {
        guard let prepare = prepare else { return }
        dailyItems(prepare) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
        }
    }

    func getEKEvent() -> EKEvent? {
        return nil// EKEventStore.shared.even
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

    func handleReminders() {
        if saveToICal == true {
            addPreparationLink(preparationID: preparation?.qotId)
        } else {
            removePreparationLink()
        }
    }

    func addPreparationLink(preparationID: String?) {
        guard let permissionManager = AppCoordinator.permissionsManager else { return }
        getEKEvent()?.addPreparationLink(preparationID: preparationID, permissionsManager: permissionManager)
    }

    func removePreparationLink() {
        do {
            try getEKEvent()?.removePreparationLink()
        } catch {
            log("Error while trying to remove PreparationLink error: \(error.localizedDescription)", level: .debug)
        }
    }
}

// MARK: - Update, Delete
extension PrepareResultsWorker {
    func updatePreparation(_ completion: @escaping (QDMUserPreparation?) -> Void) {
        guard let preparation = preparation else { return }
        PreparationManager.main.update(preparation) { [weak self] (preparation) in
            self?.handleReminders()
            completion(preparation)
        }
    }

    func deletePreparationIfNeeded(_ completion: @escaping () -> Void) {
        if let preparation = preparation, canDelete == true {
            PreparationManager.main.delete(preparation: preparation, completion: completion)
        } else {
            completion()
        }
    }
}

// MARK: - DTViewModel
extension PrepareResultsWorker {
    func getDTViewModel(_ key: Prepare.Key, _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void) {
        currentEditKey = key
        let answerFilter = preparation?.answerFilter ?? ""
        QuestionService.main.question(with: key.questionID, in: .Prepare_3_0) { (qdmQuestion) in
            guard let qdmQuestion = qdmQuestion else { return }
            let question = DTViewModel.Question(qdmQuestion: qdmQuestion)
            let filteredAnswers = qdmQuestion.answers.filter { $0.keys.contains(answerFilter) }
            let answers = filteredAnswers.compactMap { DTViewModel.Answer(qdmAnswer: $0) }
            completion(DTViewModel(question: question,
                                   answers: answers,
                                   events: [],
                                   tbvText: nil,
                                   hasTypingAnimation: false,
                                   typingAnimationDuration: 0,
                                   previousButtonIsHidden: true,
                                   dismissButtonIsHidden: false,
                                   showNextQuestionAutomated: false),
                       qdmQuestion)
        }
    }
}
