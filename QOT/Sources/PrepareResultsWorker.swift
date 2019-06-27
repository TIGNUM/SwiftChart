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
            generateDailyItemsAndUpdateView(preparation)
        case .LEVEL_DAILY:
            generateDailyItemsAndUpdateView(preparation)
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

    // TODO: Check if answerFilter really needed, looks like it just getting passed around....
    lazy var answerFilter: String? = {
        if level == .LEVEL_CRITICAL && preparation?.answerFilter?.isEmpty == false {
            return preparation?.answerFilter
        }
        return filteredAnswers(.eventType, getSelectedAnswers).first?.answer.keys.filter {
            $0.contains(DecisionTreeModel.Filter.FILTER_RELATIONSHIP)
        }.first
    }()
}

// MARK: - Getter & Setter

extension PrepareResultsWorker {
    var getCalendarEvent: QDMUserCalendarEvent? {
        return nil
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

    var getSelectedAnswers: [DecisionTreeModel.SelectedAnswer] {
        return answers
    }

    var suggestedStrategyId: Int {
        return preparation?.relatedStrategyId ?? 0
    }

    var saveToICal: Bool {
        get { return preparation?.setICalDeepLink ?? false }
        set { preparation?.setICalDeepLink = newValue }
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
}

// MARK: - Generate

private extension PrepareResultsWorker {
    func setAnswerIdsIfNeeded(_ answers: [DecisionTreeModel.SelectedAnswer]) {
        if !answers.isEmpty {
            preceiveAnswerIds = filteredAnswers(.perceived, answers).compactMap { $0.answer.remoteID.value }
            knowAnswerIds = filteredAnswers(.know, answers).compactMap { $0.answer.remoteID.value }
            feelAnswerIds = filteredAnswers(.feel, answers).compactMap { $0.answer.remoteID.value }
        }
    }

    func generateCriticalItemsAndUpdateView(_ prepare: QDMUserPreparation?) {
        guard let prepare = prepare else { return }
        criticalItems(prepare, prepare.answerFilter ?? "") { [weak self] items in
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
        strategyIds = selectedIds
        switch level {
        case .LEVEL_DAILY:
            generateDailyItemsAndUpdateView(preparation)
        case .LEVEL_CRITICAL:
            generateCriticalItemsAndUpdateView(preparation)
        default:
            break
        }
    }

    func updateIntentions(_ answers: [DecisionTreeModel.SelectedAnswer], _ key: Prepare.Key) {
        switch key {
        case .perceived:
            preceiveAnswerIds = filteredAnswers(key, answers).compactMap { $0.answer.remoteID.value }
        case .know:
            knowAnswerIds = filteredAnswers(key, answers).compactMap { $0.answer.remoteID.value }
        case .feel:
            feelAnswerIds = filteredAnswers(key, answers).compactMap { $0.answer.remoteID.value }
        default:
            break
        }
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
        guard let permissionManager = AppCoordinator.appState.permissionsManager else { return }
        getEKEvent()?.addPreparationLink(preparationID: preparationID, permissionsManager: permissionManager)
    }

    func removePreparationLink() {
        do {
            try getEKEvent()?.removePreparationLink()
        } catch {
            log("Error while trying to remove PreparationLink t: \(error.localizedDescription)",
                level: Logger.Level.debug)
        }
    }
}

// MARK: - Save

extension PrepareResultsWorker {
    func updatePreparation(_ completion: @escaping (QDMUserPreparation?, Error?) -> Void) {
        guard let preparation = preparation else { return }
        qot_dal.UserService.main.updateUserPreparation(preparation) { [weak self] (preparation, error) in
            self?.handleReminders()
            completion(preparation, error)
        }
    }

    func deletePreparationIfNeeded() {
        guard let preparation = preparation, canDelete == true else { return }
        qot_dal.UserService.main.deleteUserPreparation(preparation) { (error) in
            if let error = error {
                log("Error while trying to delete preparation:\(error.localizedDescription)", level: Logger.Level.debug)
            }
        }
    }
}
