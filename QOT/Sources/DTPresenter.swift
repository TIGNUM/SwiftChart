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
    weak var viewController: DTViewControllerInterface?

    // MARK: - Init
    init(viewController: DTViewControllerInterface?) {
        self.viewController = viewController
    }

    // MARK: - DTPresenterInterface
    func showNextQuestion(_ presentationModel: DTPresentationModel, isDark: Bool) {
        let button = getNavigationButton(presentationModel, isDark: isDark)
        viewController?.setNavigationButton(button)
        let viewModel = createViewModel(presentationModel)
        viewController?.showNextQuestion(viewModel)
    }

    func showPreviousQuestion(_ presentationModel: DTPresentationModel, selectedIds: [Int], isDark: Bool) {
        let button = getNavigationButton(presentationModel, isDark: isDark)
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

    func getNavigationButton(_ presentationModel: DTPresentationModel, isDark: Bool) -> NavigationButton? {
        return presentationModel.getNavigationButton(isHidden: false, isDark: isDark)
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

    func getHtmlTitleString(_ qdmQuestion: QDMQuestion?) -> String? {
        return nil
    }

    func getVotes(answer: QDMAnswer, poll: QDMTeamToBeVisionPoll?) -> Int {
        return 0
    }

    func createViewModel(_ presentationModel: DTPresentationModel) -> DTViewModel {
        let question = getQuestion(presentationModel.question, questionUpdate: presentationModel.questionUpdate)
        let answers = getAnswers(presentationModel.answerFilter,
                                 question: presentationModel.question,
                                 presentationModel: presentationModel)
        return DTViewModel(question: question,
                           answers: answers,
                           tbvText: presentationModel.tbv?.text,
                           userInputText: presentationModel.userInputText,
                           hasTypingAnimation: hasTypingAnimation(answerType: question.answerType, answers: answers),
                           typingAnimationDuration: question.duration,
                           previousButtonIsHidden: previousIsHidden(questionKey: question.key),
                           dismissButtonIsHidden: dismissButtonIsHidden(questionKey: question.key),
                           showNextQuestionAutomated: showNextQuestionAutomated(questionKey: question.key))
    }

    func getQuestion(_ question: QDMQuestion?, questionUpdate: String?) -> DTViewModel.Question {
        var title = question?.title
        if let update = updatedQuestionTitle(question, replacement: questionUpdate) {
            title = update
        }
        let htmlTitleString = getHtmlTitleString(question)
        return DTViewModel.Question(remoteId: question?.remoteID ?? 0,
                                    title: title ?? String.empty,
                                    htmlTitleString: htmlTitleString,
                                    key: question?.key ?? String.empty,
                                    answerType: AnswerType(rawValue: question?.answerType ?? String.empty) ?? .accept,
                                    duration: question?.layout?.animation?.duration ?? 3.0,
                                    maxSelections: question?.maxPossibleSelections ?? 0)
    }

    func getAnswers(_ answerFilter: String?,
                    question: QDMQuestion?,
                    presentationModel: DTPresentationModel) -> [DTViewModel.Answer] {
        let filteredAnswers = getFilteredAnswers(answerFilter, question: question)
        if !presentationModel.selectedIds.isEmpty {
            return filteredAnswers.compactMap { DTViewModel.Answer(qdmAnswer: $0,
                                                                   selectedIds: presentationModel.selectedIds,
                                                                   decisions: $0.getDTViewModelAnswerDecisions(),
                                                                   votes: getVotes(answer: $0,
                                                                                   poll: presentationModel.poll)) }
        }
        return filteredAnswers.compactMap { (answer) -> DTViewModel.Answer in
            let selected = answer.subtitle?.isEmpty == true && question?.answerType == AnswerType.accept.rawValue
            return DTViewModel.Answer(remoteId: answer.remoteID ?? 0,
                                      title: answer.subtitle ?? String.empty,
                                      keys: answer.keys,
                                      selected: selected,
                                      backgroundColor: answerBackgroundColor(answer: answer),
                                      decisions: answer.getDTViewModelAnswerDecisions(),
                                      votes: getVotes(answer: answer, poll: presentationModel.poll))
        }
    }

    func getFilteredAnswers(_ answerFilter: String?, question: QDMQuestion?) -> [QDMAnswer] {
        guard let filter = answerFilter else { return question?.answers ?? [] }
        return question?.answers.filter { $0.keys.contains(filter) } ?? []
    }
}
