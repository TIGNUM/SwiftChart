//
//  DTSprintPresenter.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintPresenter {

    // MARK: - Properties
    private var viewController: DTSprintViewControllerInterface?

    // MARK: - Init
    init(viewController: DTSprintViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - DTSprintInterface
extension DTSprintPresenter: DTSprintPresenterInterface {
    func showNextQuestion(_ presentationModel: PresentationModel) {
        let viewModel = createViewModel(presentationModel)
        viewController?.showNextQuestion(viewModel)
    }

    func setupView() {
        viewController?.setupView(.sand, .carbonDark)
    }

    func showPreviosQuestion(_ presentationModel: PresentationModel) {
        let viewModel = createViewModel(presentationModel)
        viewController?.showPreviosQuestion(viewModel)
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        viewController?.presentInfoView(icon: icon, title: title, text: text)
    }
}

// MARK: - ViewModel
private extension DTSprintPresenter {
    func createViewModel(_ presentationModel: PresentationModel) -> ViewModel {
        let question = getQuestion(presentationModel.question, titleToUpdate: presentationModel.titleToUpdate)
        let answers = getAnswers(presentationModel.answerFilter, question: presentationModel.question)
        let navigstionButton = getNavigationButton(question: presentationModel.question)
        let hasTypingAnimation = question.answerType == .noAnswerRequired && !answers.filter { $0.title.isEmpty }.isEmpty
        let previousIsHidden = question.key == .Intro || question.key == .Last
        let dismissButtonIsHidden = question.key == .Last
        return ViewModel(question: question,
                         answers: answers,
                         navigationButton: navigstionButton,
                         hasTypingAnimation: hasTypingAnimation,
                         previousButtonIsHidden: previousIsHidden,
                         dismissButtonIsHidden: dismissButtonIsHidden)

    }

    func getQuestion(_ question: QDMQuestion?, titleToUpdate: String?) -> ViewModel.Question {
        var title = question?.title
        if let update = titleToUpdate {
            title = question?.title.replacingOccurrences(of: "${sprintName}", with: update)
        }
        return ViewModel.Question(title: title ?? "",
                                  key: question?.key ?? "",
                                  answerType: AnswerType(rawValue: question?.answerType ?? "") ?? .accept)
    }

    func getAnswers(_ answerFilter: String?, question: QDMQuestion?) -> [ViewModel.Answer] {
        let filteredAnswers = getFilteredAnswers(answerFilter, question: question)
        return filteredAnswers.compactMap { (answer) -> ViewModel.Answer in
            let selected = answer.subtitle?.isEmpty == true && question?.answerType == AnswerType.accept.rawValue
            let backgroundColor: UIColor = answer.keys.contains(DTSprintModel.AnswerKey.AddToQueue) ? .carbonNew : .clear
            return ViewModel.Answer(remoteId: answer.remoteID ?? 0,
                                    title: answer.subtitle ?? "",
                                    keys: answer.keys,
                                    selected: selected,
                                    backgroundColor: backgroundColor,
                                    decisions: getDecisions(answer: answer))
        }
    }

    func getDecisions(answer: QDMAnswer) -> [ViewModel.Answer.Decision] {
        return answer.decisions.compactMap { (decision) -> ViewModel.Answer.Decision in
            return ViewModel.Answer.Decision(targetType: TargetType(rawValue: decision.targetType) ?? .question,
                                             targetTypeId: decision.targetTypeId)
        }
    }

    func getNavigationButton(question: QDMQuestion?) -> NavigationButton? {
        if question?.defaultButtonText?.isEmpty == true && question?.confirmationButtonText?.isEmpty == true {
            return nil
        }
        let title = question?.defaultButtonText?.isEmpty == true ? question?.confirmationButtonText : question?.defaultButtonText
        return NavigationButton(title: title ?? "", backgroundColor: .carbonNew, titleColor: .accent, type: .sprint)
    }

    func getFilteredAnswers(_ answerFilter: String?, question: QDMQuestion?) -> [QDMAnswer] {
        guard let filter = answerFilter else { return question?.answers ?? [] }
        return question?.answers.filter { $0.keys.contains(filter) } ?? []
    }
}
