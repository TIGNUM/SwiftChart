//
//  DTSprintInteractor.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//
import Foundation
import UIKit
import qot_dal

final class DTSprintInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var sprintWorker: DTSprintWorker? = DTSprintWorker()
    private var activeSprint: QDMSprint?
    private var newSprintContentId: Int?
    private var lastSprintQuestionId: Int?
    private var selectedSprintContentId: Int = 0
    private var selectedSprintTargetQuestionId: Int = 0
    private var lastQuestionSelection: DTSelectionModel?
    private var selectedSprintTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        checkNotificationPermissions()
    }

    init(_ presenter: DTPresenterInterface, questionGroup: QuestionGroup, introKey: String, isPresentedFromCoach: Bool) {
        super.init(presenter, questionGroup: questionGroup, introKey: introKey)
        sprintWorker?.isPresentedFromCoach = isPresentedFromCoach
    }

    override func getTitleUpdate(selectedAnswers: [DTViewModel.Answer],
                                    questionKey: String?,
                                    content: QDMContentCollection?) -> String? {
        let firstSelectedAnswer = selectedAnswers.first
        if firstSelectedAnswer?.keys.contains(Sprint.AnswerKey.SelectionAnswer) == true {
            selectedSprintContentId = firstSelectedAnswer?.targetId(.content) ?? 0
            selectedSprintTargetQuestionId = firstSelectedAnswer?.targetId(.question) ?? 0
            selectedSprintTitle = firstSelectedAnswer?.title ?? ""
            var result = ""
            if questionKey == Sprint.QuestionKey.Schedule {
                let sprintTitle = content?.contentItems.filter { $0.format == .header1 }.first?.valueText ?? ""
                let title = (content?.contentCategoryTitle ?? "") + ": " + sprintTitle + "\n"
                result.append(title)
                let filteredItems = content?.contentItems.filter { $0.format == .title }
                filteredItems?.reversed().forEach { result.append("\n" + "\n" + $0.valueText) }
                return result
            }
            return firstSelectedAnswer?.title
        } else if
            firstSelectedAnswer?.keys.contains(Sprint.AnswerKey.StartTomorrow) == true ||
                firstSelectedAnswer?.keys.contains(Sprint.AnswerKey.AddToQueue) == true {
            return selectedSprintTitle
        }
        return nil
    }

    override func loadNextQuestion(selection: DTSelectionModel) {
        selectedAnswers.append(SelectedAnswer(question: selection.question, answers: selection.selectedAnswers))
        if selection.question?.key == Sprint.QuestionKey.Selection {
            let contentId = selection.selectedAnswers.first?.decisions.filter { $0.targetType == TargetType.content }.first?.targetTypeId ?? 0
            sprintWorker?.getContent(contentId: contentId, completion: { [weak self] (content) in
                if let presentationModel = self?.createPresentationModel(selection: selection,
                                                                         questions: self?.questions ?? [],
                                                                         content: content) {
                    self?.presenter?.showNextQuestion(presentationModel, isDark: self?.isDark ?? true)
                    let node = Node(questionId: presentationModel.question?.remoteID,
                                    answerFilter: selection.answerFilter,
                                    titleUpdate: presentationModel.questionUpdate)
                    self?.presentedNodes.append(node)
                }
            })
        } else {
            let presentationModel = createPresentationModel(selection: selection, questions: questions, content: nil)
            presenter?.showNextQuestion(presentationModel, isDark: isDark)
            let node = Node(questionId: presentationModel.question?.remoteID,
                            answerFilter: selection.answerFilter,
                            titleUpdate: presentationModel.questionUpdate)
            presentedNodes.append(node)
        }
    }
}

// MARK: - Sprint Handling
extension DTSprintInteractor: DTSprintInteractorInterface {
    func isPresentedFromCoach() -> Bool {
        return sprintWorker?.isPresentedFromCoach ?? false
    }

    func startSprintTomorrow(selection: DTSelectionModel) {
        lastQuestionSelection = selection
        sprintWorker?.isSprintInProgress { [weak self] (sprint, endDate) in
            if let sprint = sprint, let endDate = endDate {
                let dateString = DateFormatter.settingsUser.string(from: endDate)
                self?.activeSprint = sprint
                self?.newSprintContentId = self?.selectedSprintContentId
                self?.lastSprintQuestionId = self?.selectedSprintTargetQuestionId
                let title = AppTextService.get(.my_qot_my_sprints_my_sprint_details_alert_sprint_in_progress_title)
                let messageFormat = AppTextService.get(.coach_sprints_alert_sprint_in_progress_body)
                let updatedMessageFormat = self?.replaceMessagePlaceHolders(sprintInProgressTitle: sprint.title ?? "",
                                                                            newSprintTitle: self?.selectedSprintTitle ?? "",
                                                                            message: messageFormat)
                let message = String(format: updatedMessageFormat ?? "", dateString, self?.selectedSprintTitle ?? "")
                self?.presenter?.presentInfoView(icon: R.image.ic_warning_circle(), title: title, text: message)
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
        let tempMessage = message.replacingOccurrences(of: "[NAME of SPRINT IN PROGRESS]", with: sprintInProgressTitle.uppercased())
        return tempMessage.replacingOccurrences(of: "[NAME OF NEW SPRINT]", with: newSprintTitle.uppercased())
    }

    func checkNotificationPermissions() {
        guard let worker = sprintWorker, let presenter = presenter as? DTSprintPresenterInterface else {  return }
        worker.checkNotificationPermissions { (action) in
            switch action {
            case .permission: presenter.presentPermissionView(.notification)
            case .settings: presenter.presentPermissionView(.notificationOpenSettings)
            case .none: break
            }
        }
    }
}
