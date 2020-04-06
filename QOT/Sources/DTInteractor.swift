//
//  DTInteractor.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

typealias SelectedAnswer = (question: DTViewModel.Question?, answers: [DTViewModel.Answer])
typealias Node = (questionId: Int?, answerFilter: String?, titleUpdate: String?)

class DTInteractor: DTInteractorInterface {

    // MARK: - Properties
    lazy var worker: DTWorker? = DTWorker()
    let presenter: DTPresenterInterface?
    let questionGroup: QuestionGroup
    let introKey: String
    var questions: [QDMQuestion] = []
    var presentedNodes: [Node] = []
    var selectedAnswers: [SelectedAnswer] = []
    var inputText: String = ""
    var isDark: Bool = false    //TODO Maybe we wanna have ThemeModel in the future…
    var tbv: QDMToBeVision?

    // MARK: - Init
    init(_ presenter: DTPresenterInterface, questionGroup: QuestionGroup, introKey: String) {
        self.introKey = introKey
        self.presenter = presenter
        self.questionGroup = questionGroup
        if questionGroup == .MindsetShifterToBeVision && introKey == ShortTBV.QuestionKey.IntroOnboarding {
            isDark = true
        }
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker?.getQuestions(questionGroup: questionGroup) { [weak self] (questions) in
            self?.questions = questions ?? []
            let firstQuestion = questions?.filter { $0.key == self?.introKey }.first
            self?.loadIntroQuestion(firstQuestion)
        }
    }

    func loadIntroQuestion(_ firstQuestion: QDMQuestion?) {
        let presentationModel = DTPresentationModel(question: firstQuestion)
        let node = Node(questionId: firstQuestion?.remoteID,
                        answerFilter: nil,
                        titleUpdate: nil)
        presentedNodes.append(node)
        presenter?.showNextQuestion(presentationModel, isDark: isDark)
    }

    // MARK: - DTInteractorInterface
    func getSelectedAnswers() -> [SelectedAnswer] {
        return selectedAnswers
    }

    func getSelectedIds() -> [Int] {
        return selectedAnswers.flatMap { $0.answers }.compactMap { $0.remoteId }
    }

    func didStopTypingAnimationPresentNextPage(viewModel: DTViewModel?) {
        let selectionModel = DTSelectionModel(selectedAnswers: viewModel?.answers ?? [], question: viewModel?.question)
        loadNextQuestion(selection: selectionModel)
    }

    func didStopTypingAnimation() {
        presenter?.showNavigationButtonAfterAnimation()
    }

    func loadNextQuestion(selection: DTSelectionModel) {
        selectedAnswers.append(SelectedAnswer(question: selection.question, answers: selection.selectedAnswers))
        let presentationModel = createPresentationModel(selection: selection, questions: questions, content: nil)
        presenter?.showNextQuestion(presentationModel, isDark: isDark)
        let node = Node(questionId: presentationModel.question?.remoteID,
                        answerFilter: selection.answerFilter,
                        titleUpdate: presentationModel.questionUpdate)
        presentedNodes.append(node)
    }

    func loadPreviousQuestion(selectedIds: [Int]) -> Bool {
        if !presentedNodes.isEmpty {
            presentedNodes.removeLast()
            if !selectedAnswers.isEmpty {
                selectedAnswers.removeLast()
            }
            guard let lastNode = presentedNodes.last else {
                return false
            }
            let presentationModel = createPresentationModel(questionId: lastNode.questionId,
                                                            answerFilter: lastNode.answerFilter,
                                                            userInputText: inputText,
                                                            questionUpdate: lastNode.titleUpdate,
                                                            selectedIds: selectedIds,
                                                            questions: questions)
            presenter?.showPreviousQuestion(presentationModel, selectedIds: selectedIds, isDark: isDark)
            return true
        }
        return false
    }

    var getIntroKey: String {
        return introKey
    }

    // MARK: - Create DTPresentationModel
    func createPresentationModel(questionId: Int??,
                                 answerFilter: String?,
                                 userInputText: String?,
                                 questionUpdate: String?,
                                 selectedIds: [Int],
                                 questions: [QDMQuestion]) -> DTPresentationModel {
        let question = questions.filter { $0.remoteID == questionId }.first
        let tbv = getTBV(questionAnswerType: question?.answerType, questionKey: question?.key)
        let events = getEvents(questionKey: question?.key)
        let preparations = getPreparations(answerKeys: selectedAnswers.last?.answers.first?.keys)
        let filter = getAnswerFilter(questionKey: question?.key,
                                     answerFilter: answerFilter)
        return DTPresentationModel(question: question,
                                   questionUpdate: questionUpdate,
                                   answerFilter: filter,
                                   userInputText: userInputText,
                                   tbv: tbv,
                                   selectedIds: selectedIds,
                                   events: events,
                                   preparations: preparations)
    }

    func createPresentationModel(selection: DTSelectionModel,
                                 questions: [QDMQuestion],
                                 content: QDMContentCollection?) -> DTPresentationModel {
        let question = getNextQuestion(selection: selection, questions: questions)
        let questionUpdate = getTitleUpdate(selectedAnswers: selection.selectedAnswers,
                                            questionKey: question?.key,
                                            content: content)
        let tbv = getTBV(questionAnswerType: question?.answerType, questionKey: question?.key)
        let events = getEvents(questionKey: question?.key)
        let preparations = getPreparations(answerKeys: selection.selectedAnswers.first?.keys)
        let answerFilter = getAnswerFilter(questionKey: question?.key,
                                           answerFilter: selection.answerFilter)
        return DTPresentationModel(question: question,
                                   questionUpdate: questionUpdate,
                                   answerFilter: answerFilter,
                                   userInputText: selection.userInput,
                                   tbv: tbv,
                                   selectedIds: [],
                                   events: events,
                                   preparations: preparations)
    }

    func getNextQuestion(selection: DTSelectionModel, questions: [QDMQuestion]) -> QDMQuestion? {
        let targetQuestionId = selection.selectedAnswers.first?.targetId(.question)
        return questions.filter { $0.remoteID == targetQuestionId }.first
    }

    func getTitleUpdate(selectedAnswers: [DTViewModel.Answer],
                        questionKey: String?,
                        content: QDMContentCollection?) -> String? {
        return nil
    }

    func getTBV(questionAnswerType: String?, questionKey: String?) -> QDMToBeVision? {
        return nil
    }

    func getEvents(questionKey: String?) -> [QDMUserCalendarEvent] {
        return []
    }

    func getCalendarSetting() -> [QDMUserCalendarSetting] {
        return []
    }

    func getPreparations(answerKeys: [String]?) -> [QDMUserPreparation] {
        return []
    }

    func getAnswerFilter(questionKey: String?, answerFilter: String?) -> String? {
        return answerFilter
    }

    // MARK: - TBV
    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void) {
        if tbv != nil {
            completion(tbv, true)
        } else {
            worker?.getUsersTBV { (tbv, initiated) in
                self.tbv = tbv
                completion(tbv, initiated)
            }
        }
    }

    func didUpdateUserInput(_ text: String, questionKey: String) {
        inputText = text
        presenter?.showNavigationButtonAfterAnimation()
    }
}
