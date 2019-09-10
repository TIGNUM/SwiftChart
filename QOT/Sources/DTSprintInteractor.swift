//
//  DTSprintInteractor.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var sprintWorker: DTSprintWorker? = DTSprintWorker()
    private var activeSprint: QDMSprint?
    private var sprintToUpdate: QDMSprint?
    private var newSprintContentId: Int?
    private var lastSprintQuestionId: Int?
    private var selectedSprintContentId: Int = 0
    private var selectedSprintTargetQuestionId: Int = 0
    private var lastQuestionSelection: DTSelectionModel?
    private var selectedSprintTitle = ""

    override func getTitleToUpdate(selectedAnswer: DTViewModel.Answer?) -> String? {
        if selectedAnswer?.keys.contains(Sprint.AnswerKey.SelectionAnswer) == true {
            selectedSprintContentId = selectedAnswer?.targetId(.content) ?? 0
            selectedSprintTargetQuestionId = selectedAnswer?.targetId(.question) ?? 0
            selectedSprintTitle = selectedAnswer?.title ?? ""
            return selectedAnswer?.title
        } else if
            selectedAnswer?.keys.contains(Sprint.AnswerKey.StartTomorrow) == true ||
                selectedAnswer?.keys.contains(Sprint.AnswerKey.AddToQueue) == true {
            return selectedSprintTitle
        }
        return nil
    }
}

// MARK: - Sprint Handling
extension DTSprintInteractor: DTSprintInteractorInterface {
    func startSprintTomorrow(selection: DTSelectionModel) {
        lastQuestionSelection = selection
        sprintWorker?.isSprintInProgress { [weak self] (sprint, endDate) in
            if let sprint = sprint, let endDate = endDate {
                let dateString = DateFormatter.settingsUser.string(from: endDate)
                self?.activeSprint = sprint
                self?.newSprintContentId = self?.selectedSprintContentId
                self?.lastSprintQuestionId = self?.selectedSprintTargetQuestionId
                let title = ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoTitleSprintInProgress)
                let messageFormat = ScreenTitleService.main.localizedString(for: .MySprintDetailsInfoBodyInProgress)
                let updatedMessageFormat = self?.replaceMessagePlaceHolders(sprintInProgressTitle: sprint.title ?? "",
                                                                            newSprintTitle: self?.selectedSprintTitle ?? "",
                                                                            message: messageFormat)
                let message = String(format: updatedMessageFormat ?? "", dateString, self?.selectedSprintTitle ?? "")
                self?.presenter.presentInfoView(icon: R.image.ic_warning_circle(), title: title, text: message)
            } else {
                self?.sprintWorker?.startSprintTomorrow(selectedSprintContentId: self?.selectedSprintContentId ?? 0)
                if let selection = self?.lastQuestionSelection {
                    self?.loadNextQuestion(selection: selection)
                }
            }
        }
    }

    func addSprintToQueue(selection: DTSelectionModel) {
        sprintWorker?.addSprintToQueue(sprintContentId: selectedSprintContentId)
        loadNextQuestion(selection: selection)
    }

    func stopActiveSprintAndStartNewSprint() {
        sprintWorker?.stopActiveSprintAndStartNewSprint(activeSprint: activeSprint, newSprintContentId: newSprintContentId)
        if let selection = lastQuestionSelection {
            self.loadNextQuestion(selection: selection)
        }
    }

    func getSelectedSprintTitle() -> String? {
        return selectedSprintTitle
    }
}

// MARK: - Private
private extension DTSprintInteractor {
    func replaceMessagePlaceHolders(sprintInProgressTitle: String, newSprintTitle: String, message: String) -> String {
        let tempMessage = message.replacingOccurrences(of: "[NAME of SPRINT IN PROGRESS]\'s", with: sprintInProgressTitle)
        return tempMessage.replacingOccurrences(of: "[NAME OF NEW SPRINT]", with: newSprintTitle)
    }
}
