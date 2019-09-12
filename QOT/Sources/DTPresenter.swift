//
//  DTPresenter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class DTPresenter: DTPresenterInterface {

    // MARK: - Properties
    private var viewController: DTViewControllerInterface?

    // MARK: - Init
    init(viewController: DTViewControllerInterface?) {
        self.viewController = viewController
    }

    // MARK: - DTPresenterInterface
    func setupView() {
        viewController?.setupView(.sand, .carbonDark)
    }

    func showNextQuestion(_ presentationModel: DTPresentationModel) {
        let button = presentationModel.getNavigationButton(isHidden: false)
        viewController?.setNavigationButton(button)
        let viewModel = createViewModel(presentationModel)
        viewController?.showNextQuestion(viewModel)
    }

    func showPreviosQuestion(_ presentationModel: DTPresentationModel) {
        let button = presentationModel.getNavigationButton(isHidden: false)
        viewController?.setNavigationButton(button)
        let viewModel = createViewModel(presentationModel)
        viewController?.showPreviosQuestion(viewModel)
    }

    func showNavigationButtonAfterAnimation() {
        viewController?.showNavigationButtonAfterAnimation()
    }

    func hideNavigationButtonForAnimation() {
        viewController?.hideNavigationButtonForAnimation()
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        viewController?.presentInfoView(icon: icon, title: title, text: text)
    }

    // MARK: - Create DTViewModel
    func updatedQuestionTitle(_ question: QDMQuestion?, replacement: String?) -> String? {
        return nil
    }

    func previousIsHidden(questionKey: String) -> Bool {
        return false
    }

    func dismissButtonIsHidden(questionKey: String) -> Bool {
        return false
    }

    func hasTypingAnimation(answerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
        return false
    }

    func answerBackgroundColor(answer: QDMAnswer) -> UIColor {
        return .clear
    }

    func showNextQuestionAutomated(questionKey: String) -> Bool {
        return false
    }

    func createViewModel(_ presentationModel: DTPresentationModel) -> DTViewModel {
        let question = getQuestion(presentationModel.question, titleToUpdate: presentationModel.titleToUpdate)
        let answers = getAnswers(presentationModel.answerFilter, question: presentationModel.question)
        return DTViewModel(question: question,
                           answers: answers,
                           tbvText: presentationModel.tbv?.text,
                           hasTypingAnimation: hasTypingAnimation(answerType: question.answerType, answers: answers),
                           typingAnimationDuration: 5.0,
                           previousButtonIsHidden: previousIsHidden(questionKey: question.key),
                           dismissButtonIsHidden: dismissButtonIsHidden(questionKey: question.key),
                           showNextQuestionAutomated: showNextQuestionAutomated(questionKey: question.key))
    }

    func getQuestion(_ question: QDMQuestion?, titleToUpdate: String?) -> DTViewModel.Question {
        var title = question?.title
        if let update = updatedQuestionTitle(question, replacement: titleToUpdate) {
            title = update
        }
        return DTViewModel.Question(remoteId: question?.remoteID ?? 0,
                                    title: title ?? "",
                                    key: question?.key ?? "",
                                    answerType: AnswerType(rawValue: question?.answerType ?? "") ?? .accept,
                                    duration: question?.answerType == nil ? 0.0 : 5.0,
                                    maxSelections: question?.maxPossibleSelections ?? 0)
    }

    func getAnswers(_ answerFilter: String?, question: QDMQuestion?) -> [DTViewModel.Answer] {
        let filteredAnswers = getFilteredAnswers(answerFilter, question: question)
        return filteredAnswers.compactMap { (answer) -> DTViewModel.Answer in
            let selected = answer.subtitle?.isEmpty == true && question?.answerType == AnswerType.accept.rawValue
            return DTViewModel.Answer(remoteId: answer.remoteID ?? 0,
                                      title: answer.subtitle ?? "",
                                      keys: answer.keys,
                                      selected: selected,
                                      backgroundColor: answerBackgroundColor(answer: answer),
                                      decisions: getDecisions(answer: answer))
        }
    }

    func getDecisions(answer: QDMAnswer) -> [DTViewModel.Answer.Decision] {
        return answer.decisions.compactMap { (decision) -> DTViewModel.Answer.Decision in
            return DTViewModel.Answer.Decision(targetType: TargetType(rawValue: decision.targetType) ?? .question,
                                               targetTypeId: decision.targetTypeId)
        }
    }

    func getFilteredAnswers(_ answerFilter: String?, question: QDMQuestion?) -> [QDMAnswer] {
        guard let filter = answerFilter else { return question?.answers ?? [] }
        return question?.answers.filter { $0.keys.contains(filter) } ?? []
    }
}
