//
//  DTInteractor.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class DTInteractor: DTInteractorInterface {

    // MARK: - Properties
    typealias Node = (questionId: Int?, answerFilter: String?)
    lazy var worker: DTWorker? = DTWorker()
    let presenter: DTPresenterInterface
    let questionGroup: QuestionGroup
    let introKey: String
    var questions: [QDMQuestion] = []
    var presentedNodes: [Node] = []

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
            let presentationModel = DTPresentationModel(question: firstQuestion, titleToUpdate: nil, answerFilter: nil)
            let node = Node(questionId: firstQuestion?.remoteID, answerFilter: nil)
            self?.presentedNodes.append(node)
            self?.presenter.showNextQuestion(presentationModel)
        }
    }

    // MARK: - DTInteractorInterface
    func didStopTypingAnimation(answer: DTViewModel.Answer?) {
        let selectionModel = DTSelectionModel(selectedAnswer: answer)
        loadNextQuestion(selection: selectionModel)
    }

    func loadNextQuestion(selection: DTSelectionModel) {
        let presentationModel = createPresentationModel(selection: selection, questions: questions)
        presenter.showNextQuestion(presentationModel)
        let node = Node(questionId: presentationModel.question?.remoteID, answerFilter: selection.answerFilter)
        presentedNodes.append(node)
    }

    func loadPreviousQuestion() {
        presentedNodes.removeLast()
        let lastNode = presentedNodes.last
        let presentationModel = createPresentationModel(questionId: lastNode?.questionId,
                                                        answerFilter: lastNode?.answerFilter,
                                                        questions: questions)
        presenter.showPreviosQuestion(presentationModel)
    }

    // MARK: - Create DTPresentationModel
    func createPresentationModel(questionId: Int??, answerFilter: String?, questions: [QDMQuestion]) -> DTPresentationModel {
        let question = questions.filter { $0.remoteID == questionId }.first
        return DTPresentationModel(question: question, titleToUpdate: nil, answerFilter: answerFilter)
    }

    func createPresentationModel(selection: DTSelectionModel, questions: [QDMQuestion]) -> DTPresentationModel {
        let question = getNextQuestion(selectedAnswer: selection.selectedAnswer, questions: questions)
        let titleToUpdate = getTitleToUpdate(selectedAnswer: selection.selectedAnswer)
        return DTPresentationModel(question: question, titleToUpdate: titleToUpdate, answerFilter: selection.answerFilter)
    }

    func getNextQuestion(selectedAnswer: DTViewModel.Answer?, questions: [QDMQuestion]) -> QDMQuestion? {
        let targetQuestionId = selectedAnswer?.targetId(.question)
        return questions.filter { $0.remoteID == targetQuestionId }.first
    }

    func getTitleToUpdate(selectedAnswer: DTViewModel.Answer?) -> String? {
        return nil
    }

    // MARK: - TBV
    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void) {
        worker?.getUsersTBV(completion)
    }
}
