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
    private var answers: [DecisionTreeModel.SelectedAnswer] = []
    private var preparation: QDMUserPreparation?
    private var canDelete: Bool = false
    private var level: QDMUserPreparation.Level
    weak var delegate: PrepareResultsDelegatge?

    // MARK: - Init
    init(_ preparation: QDMUserPreparation?,
         _ answers: [DecisionTreeModel.SelectedAnswer],
         _ canDelete: Bool) {
        self.canDelete = canDelete
        self.answers = answers
        self.preparation = preparation
        self.level = preparation?.type ?? .LEVEL_DAILY

        switch level {
        case .LEVEL_CRITICAL:
            if answers.isEmpty {
                generateCriticalItemsAndUpdateView(preparation, suggestedStrategyId: suggestedStrategyId)
            } else {
                updateAnswerIds(answers) { [unowned self] (preparation) in
                    self.preparation = preparation
                    self.generateCriticalItemsAndUpdateView(preparation, suggestedStrategyId: self.suggestedStrategyId)
                }
            }
        case .LEVEL_DAILY:
            generateDailyItemsAndUpdateView(preparation, suggestedStrategyId: suggestedStrategyId)
        default: break
        }
    }

    init(_ contentId: Int) {
        level = .LEVEL_ON_THE_GO
        onTheGoItems(contentId) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
        }
    }

    // Texts
    lazy var leaveAlertTitle: String = {
        return R.string.localized.mindsetShifterLeaveAlertTitle()
    }()

    lazy var leaveAlertMessage: String = {
        return R.string.localized.mindsetShifterLeaveAlertMessage()
    }()

    lazy var leaveButtonTitle: String = {
        return R.string.localized.mindsetShifterLeaveAlertLeaveButton()
    }()

    lazy var cancelButtonTitle: String = {
        return R.string.localized.buttonTitleCancel()
    }()

    lazy var answerFilter: String? = {
        if level == .LEVEL_CRITICAL && preparation?.answerFilter?.isEmpty == false {
            return preparation?.answerFilter
        }
        return
            filteredAnswers(.eventType, getSelectedAnswers)
            .first?.answer.keys
            .filter { $0.contains(DecisionTreeModel.Filter.Relationship) }
            .first
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

    var getSelectedAnswers: [DecisionTreeModel.SelectedAnswer] {
        return answers
    }

    var suggestedStrategyId: Int {
        return preparation?.relatedStrategyId ?? 0
    }

    var saveToICal: Bool {
        get { return preparation?.setICalDeepLink ?? false }
        set {
            preparation?.setICalDeepLink = newValue
            updateCalendarEventLink(isOn: newValue)
        }
    }

    var setReminder: Bool {
        get { return preparation?.setReminder ?? false }
        set { preparation?.setReminder = newValue }
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
        qot_dal.CalendarService.main.getCalendarEvents { [weak self] (events, initiated, error) in
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
            if isOn == true, let permissionsManager = AppCoordinator.appState.permissionsManager {
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

    func generateCriticalItemsAndUpdateView(_ prepare: QDMUserPreparation?, suggestedStrategyId: Int?) {
        guard let prepare = prepare else { return }
        criticalItems(prepare, prepare.answerFilter ?? "", suggestedStrategyId) { [weak self] items in
            self?.items = items
            self?.delegate?.reloadData()
        }
    }

    func generateDailyItemsAndUpdateView(_ prepare: QDMUserPreparation?, suggestedStrategyId: Int?) {
        guard let prepare = prepare else { return }
        dailyItems(prepare, suggestedStrategyId) { [weak self] items in
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
            generateDailyItemsAndUpdateView(preparation, suggestedStrategyId: nil)
        case .LEVEL_CRITICAL:
            generateCriticalItemsAndUpdateView(preparation, suggestedStrategyId: nil)
        default:
            break
        }
    }

    func updateIntentions(_ answers: [DecisionTreeModel.SelectedAnswer], _ key: Prepare.Key) {
        switch key {
        case .perceived:
            preceiveAnswerIds = filteredAnswers(key, answers).compactMap { $0.answer.remoteID }
        case .know:
            knowAnswerIds = filteredAnswers(key, answers).compactMap { $0.answer.remoteID }
        case .feel:
            feelAnswerIds = filteredAnswers(key, answers).compactMap { $0.answer.remoteID }
        default:
            break
        }
        generateCriticalItemsAndUpdateView(preparation, suggestedStrategyId: suggestedStrategyId)
    }

    func updateBenefits(_ benefits: String) {
        self.benefits = benefits
        generateCriticalItemsAndUpdateView(preparation, suggestedStrategyId: suggestedStrategyId)
    }

    func handleReminders() {
        if saveToICal == true {
            addPreparationLink(preparationID: preparation?.qotId)
        } else {
            removePreparationLink()
        }
    }

    func addPreparationLink(preparationID: String?) {
        guard let permissionManager = AppCoordinator.appState.permissionsManager else { return }
        getEKEvent()?.addPreparationLink(preparationID: preparationID, permissionsManager: permissionManager)
    }

    func removePreparationLink() {
        do {
            try getEKEvent()?.removePreparationLink()
        } catch {
            log("Error while trying to remove PreparationLink error: \(error.localizedDescription)",
                level: Logger.Level.debug)
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
