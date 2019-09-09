//
//  DTSprintInteractor.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintInteractor {

    // MARK: - Properties
    private lazy var worker: DTSprintWorker? = DTSprintWorker()
    private let presenter: DTSprintPresenterInterface
    private var questions: [QDMQuestion] = []
    private var presentedQuestionIds: [Int?] = []
    private var activeSprint: QDMSprint?
    private var sprintToUpdate: QDMSprint?
    private var newSprintContentId: Int?
    private var lastSprintQuestionId: Int?
    private var selectedSprintContentId: Int = 0
    private var selectedSprintTargetQuestionId: Int = 0
    private var lastQuestionSelection: SelectionModel?
    private var selectedSprintTitle = ""

    // MARK: - Init
    init(presenter: DTSprintPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        worker?.getQuestions { [weak self] (questions) in
            self?.questions = questions ?? []
            let firstQuestion = questions?.filter { $0.key == DTSprintModel.QuestionKey.Intro }.first
            let presentationModel = PresentationModel(question: firstQuestion, titleToUpdate: nil, answerFilter: nil)
            self?.presentedQuestionIds.append(firstQuestion?.remoteID)
            self?.presenter.showNextQuestion(presentationModel)
        }
    }
}

// MARK: - DTSprintInteractorInterface Questions
extension DTSprintInteractor: DTSprintInteractorInterface {
    func getSelectedSprintTitle() -> String? {
        return selectedSprintTitle
    }

    func loadNextQuestion(selection: SelectionModel) {
        let presentationModel = createPresentationModel(selection: selection, questions: questions)
        presenter.showNextQuestion(presentationModel)
        presentedQuestionIds.append(presentationModel.question?.remoteID)
    }

    func loadPreviousQuestion() {
        presentedQuestionIds.removeLast()
        let presentationModel = createPresentationModel(questionId: presentedQuestionIds.last, questions: questions)
        presenter.showPreviosQuestion(presentationModel)
    }

    func didStopTypingAnimation(answer: ViewModel.Answer?) {
        let selectionModel = SelectionModel(selectedAnswer: answer, userInput: nil)
        loadNextQuestion(selection: selectionModel)
    }
}

// MARK: - Sprint Handling
extension DTSprintInteractor {
    func startSprintTomorrow(selection: SelectionModel) {
        lastQuestionSelection = selection
        worker?.isSprintInProgress { [weak self] (sprint, endDate) in
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
                self?.worker?.startSprintTomorrow(selectedSprintContentId: self?.selectedSprintContentId ?? 0)
                if let selection = self?.lastQuestionSelection {
                    self?.loadNextQuestion(selection: selection)
                }
            }
        }
    }

    func replaceMessagePlaceHolders(sprintInProgressTitle: String, newSprintTitle: String, message: String) -> String {
        let tempMessage = message.replacingOccurrences(of: "[NAME of SPRINT IN PROGRESS]\'s", with: sprintInProgressTitle)
        return tempMessage.replacingOccurrences(of: "[NAME OF NEW SPRINT]", with: newSprintTitle)
    }

    func addSprintToQueue(selection: SelectionModel) {
        worker?.addSprintToQueue(sprintContentId: selectedSprintContentId)
        loadNextQuestion(selection: selection)
    }

    func stopActiveSprintAndStartNewSprint() {
        worker?.stopActiveSprintAndStartNewSprint(activeSprint: activeSprint, newSprintContentId: newSprintContentId)
        if let selection = lastQuestionSelection {
            self.loadNextQuestion(selection: selection)
        }
    }
}

// MARK: - Private
private extension DTSprintInteractor {
    func createPresentationModel(questionId: Int??, questions: [QDMQuestion]) -> PresentationModel {
        let question = questions.filter { $0.remoteID == questionId }.first
        return PresentationModel(question: question, titleToUpdate: nil, answerFilter: nil)
    }

    func createPresentationModel(selection: SelectionModel, questions: [QDMQuestion]) -> PresentationModel {
        let question = getNextQuestion(selectedAnswer: selection.selectedAnswer, questions: questions)
        let titleToUpdate = getTitleToUpdate(selectedAnswer: selection.selectedAnswer)
        return PresentationModel(question: question, titleToUpdate: titleToUpdate, answerFilter: nil)
    }

    func getNextQuestion(selectedAnswer: ViewModel.Answer?, questions: [QDMQuestion]) -> QDMQuestion? {
        let targetQuestionId = selectedAnswer?.targetId(.question)
        return questions.filter { $0.remoteID == targetQuestionId }.first
    }

    func getTitleToUpdate(selectedAnswer: ViewModel.Answer?) -> String? {
        if selectedAnswer?.keys.contains(DTSprintModel.AnswerKey.SelectionAnswer) == true {
            selectedSprintContentId = selectedAnswer?.targetId(.content) ?? 0
            selectedSprintTargetQuestionId = selectedAnswer?.targetId(.question) ?? 0
            selectedSprintTitle = selectedAnswer?.title ?? ""
            return selectedAnswer?.title
        } else if
            selectedAnswer?.keys.contains(DTSprintModel.AnswerKey.StartTomorrow) == true ||
            selectedAnswer?.keys.contains(DTSprintModel.AnswerKey.AddToQueue) == true {
                return selectedSprintTitle
        }
        return nil
    }
}

// MARK: - CRUD TreeNode
private extension DTSprintInteractor {

}
