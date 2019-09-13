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
    let presenter: DTPresenterInterface
    let questionGroup: QuestionGroup
    let introKey: String
    var questions: [QDMQuestion] = []
    var presentedNodes: [Node] = []
    var selectedAnswers: [SelectedAnswer] = []
    var tbv: QDMToBeVision?

    // MARK: - Init
    init(_ presenter: DTPresenterInterface, questionGroup: QuestionGroup, introKey: String) {
        self.introKey = introKey
        self.presenter = presenter
        self.questionGroup = questionGroup
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        worker?.getQuestions(questionGroup: questionGroup) { [weak self] (questions) in
            self?.questions = questions ?? []
            let firstQuestion = questions?.filter { $0.key == self?.introKey }.first
            let presentationModel = DTPresentationModel(question: firstQuestion)
            let node = Node(questionId: firstQuestion?.remoteID, answerFilter: nil, titleUpdate: nil)
            self?.presentedNodes.append(node)
            self?.presenter.showNextQuestion(presentationModel)
        }
    }

    // MARK: - DTInteractorInterface
    func didStopTypingAnimationPresentNextPage(viewModel: DTViewModel?) {
        let selectionModel = DTSelectionModel(selectedAnswers: viewModel?.answers ?? [], question: viewModel?.question)
        loadNextQuestion(selection: selectionModel)
    }

    func didStopTypingAnimation() {
        presenter.showNavigationButtonAfterAnimation()
    }

    func loadNextQuestion(selection: DTSelectionModel) {
        selectedAnswers.append(SelectedAnswer(question: selection.question, answers: selection.selectedAnswers))
        let presentationModel = createPresentationModel(selection: selection, questions: questions)
        presenter.showNextQuestion(presentationModel)
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
            presenter.showPreviosQuestion(presentationModel)
        }
    }

    // MARK: - Create DTPresentationModel
    func createPresentationModel(questionId: Int??,
                                 answerFilter: String?,
                                 questionUpdate: String?,
                                 questions: [QDMQuestion]) -> DTPresentationModel {
        let question = questions.filter { $0.remoteID == questionId }.first
        let tbv = question?.answerType == AnswerType.text.rawValue ? self.tbv : nil
        return DTPresentationModel(question: question,
                                   questionUpdate: questionUpdate,
                                   answerFilter: answerFilter,
                                   tbv: tbv)
    }

    func createPresentationModel(selection: DTSelectionModel, questions: [QDMQuestion]) -> DTPresentationModel {
        let question = getNextQuestion(selectedAnswer: selection.selectedAnswers.first, questions: questions)
        let questionUpdate = getTitleUpdate(selectedAnswers: selection.selectedAnswers, questionKey: question?.key)
        let tbv = question?.answerType == AnswerType.text.rawValue ? self.tbv : nil
        return DTPresentationModel(question: question,
                                   questionUpdate: questionUpdate,
                                   answerFilter: selection.answerFilter,
                                   tbv: tbv)
    }

    func getNextQuestion(selectedAnswer: DTViewModel.Answer?, questions: [QDMQuestion]) -> QDMQuestion? {
        let targetQuestionId = selectedAnswer?.targetId(.question)
        return questions.filter { $0.remoteID == targetQuestionId }.first
    }

    func getTitleUpdate(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        return nil
    }

    // MARK: - TBV
    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void) {
        worker?.getUsersTBV { [weak self] (tbv, initiated) in
            self?.tbv = tbv
            completion(tbv, initiated)
        }
    }
}
