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

    // MARK: - Init
    init(_ presenter: DTPresenterInterface, questionGroup: QuestionGroup, introKey: String) {
        self.introKey = introKey
        self.presenter = presenter
        self.questionGroup = questionGroup
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter?.setupView()
        worker?.getQuestions(questionGroup: questionGroup) { [weak self] (questions) in
            self?.questions = questions ?? []
            let firstQuestion = questions?.filter { $0.key == self?.introKey }.first
            let presentationModel = DTPresentationModel(question: firstQuestion)
            let node = Node(questionId: firstQuestion?.remoteID,
                            answerFilter: nil,
                            titleUpdate: nil)
            self?.presentedNodes.append(node)
            self?.presenter?.showNextQuestion(presentationModel)
        }
    }

    // MARK: - DTInteractorInterface
    func getSelectedAnswers() -> [SelectedAnswer] {
        return selectedAnswers
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
        let presentationModel = createPresentationModel(selection: selection, questions: questions)
        presenter?.showNextQuestion(presentationModel)
        let node = Node(questionId: presentationModel.question?.remoteID,
                        answerFilter: selection.answerFilter,
                        titleUpdate: presentationModel.questionUpdate)
        presentedNodes.append(node)
    }

    func loadPreviousQuestion() {
        if presentedNodes.isEmpty == false {
            presentedNodes.removeLast()
            if selectedAnswers.isEmpty == false {
                selectedAnswers.removeLast()
            }
            let lastNode = presentedNodes.last
            let presentationModel = createPresentationModel(questionId: lastNode?.questionId,
                                                            answerFilter: lastNode?.answerFilter,
                                                            questionUpdate: lastNode?.titleUpdate,
                                                            questions: questions)
            presenter?.showPreviosQuestion(presentationModel)
        }
    }

    // MARK: - Create DTPresentationModel
    func createPresentationModel(questionId: Int??,
                                 answerFilter: String?,
                                 questionUpdate: String?,
                                 questions: [QDMQuestion]) -> DTPresentationModel {
        let question = questions.filter { $0.remoteID == questionId }.first
        let tbv = getTBV(questionAnswerType: question?.answerType, questionKey: question?.key)
        let events = getEvents(questionKey: question?.key)
        let preparations = getPreparations(answerKeys: selectedAnswers.last?.answers.first?.keys)
        return DTPresentationModel(question: question,
                                   questionUpdate: questionUpdate,
                                   answerFilter: answerFilter,
                                   tbv: tbv,
                                   events: events,
                                   preparations: preparations)
    }

    func createPresentationModel(selection: DTSelectionModel, questions: [QDMQuestion]) -> DTPresentationModel {
        let question = getNextQuestion(selection: selection, questions: questions)
        let questionUpdate = getTitleUpdate(selectedAnswers: selection.selectedAnswers, questionKey: question?.key)
        let tbv = getTBV(questionAnswerType: question?.answerType, questionKey: question?.key)
        let events = getEvents(questionKey: question?.key)
        let preparations = getPreparations(answerKeys: selection.selectedAnswers.first?.keys)
        return DTPresentationModel(question: question,
                                   questionUpdate: questionUpdate,
                                   answerFilter: selection.answerFilter,
                                   tbv: tbv,
                                   events: events,
                                   preparations: preparations)
    }

    func getNextQuestion(selection: DTSelectionModel, questions: [QDMQuestion]) -> QDMQuestion? {
        let targetQuestionId = selection.selectedAnswers.first?.targetId(.question)
        return questions.filter { $0.remoteID == targetQuestionId }.first
    }

    func getTitleUpdate(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        return nil
    }

    func getTBV(questionAnswerType: String?, questionKey: String?) -> QDMToBeVision? {
        return nil
    }

    func getEvents(questionKey: String?) -> [QDMUserCalendarEvent] {
        return []
    }

    func getPreparations(answerKeys: [String]?) -> [QDMUserPreparation] {
        return []
    }

    // MARK: - TBV
    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void) {
        worker?.getUsersTBV { (tbv, initiated) in
            completion(tbv, initiated)
        }
    }
}
