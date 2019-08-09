//
//  DecisionTreeInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DecisionTreeInteractor {

    // MARK: - Properties
    private let worker: DecisionTreeWorker
    private let presenter: DecisionTreePresenterInterface
    private let router: DecisionTreeRouterInterface

    // MARK: - Init
    init(worker: DecisionTreeWorker,
         presenter: DecisionTreePresenterInterface,
         router: DecisionTreeRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        fetchFirstQuestionAndDisplay()
    }
}

private extension DecisionTreeInteractor {
    func fetchFirstQuestionAndDisplay() {
        worker.fetchQuestions { [weak self] in
            if let question = self?.worker.firstQuestion {
                self?.showQuestion(question, animated: true)
            }
        }
    }
}

// MARK: - DecisionTreeInteractorInterface
extension DecisionTreeInteractor: DecisionTreeInteractorInterface {
    var selectedanswers: [DecisionTreeModel.SelectedAnswer] {
        return worker.selectedAnswers
    }

    var userInput: String? {
        set { worker.userInput = newValue }
        get { return worker.userInput }
    }

    var type: DecisionTreeType {
        return worker.type
    }

    var answersFilter: String? {
        return worker.answersFilter()
    }

    var extraAnswer: String? {
        return worker.extraAnswer
    }

    func displayContent(with id: Int) {
        router.openArticle(with: id)
    }

    func streamContentItem(with id: Int) {
        worker.mediaURL(from: id) { [weak self] (url) in
            if let url = url {
                self?.router.openVideo(from: url)
            }
        }
    }

    func openImagePicker() {
        router.openImagePicker()
    }

    func openShortTBVGenerator(completion: (() -> Void)?) {
        if worker.userHasToBeVision == false {
            router.openShortTBVGenerator(completion: completion)
        }
    }

    func openMindsetShifterChecklist(from answers: [QDMAnswer]) {
        if let trigger = answers.first(where: { $0.keys.filter { $0.contains("trigger-") }.isEmpty == false })?.title {
            let reactions = answers.filter { $0.keys.filter { $0.contains("reaction") }.isEmpty == false }.map { $0.title ?? "" }
            let lowItems = answers.filter { $0.keys.filter { $0.contains("lowperformance") }.isEmpty == false }.map { $0.title ?? "" }
            var contentItemIDs: [Int] = []
            answers.forEach {
                $0.decisions.forEach {
                    if $0.targetType == TargetType.contentItem.rawValue, let id = $0.targetTypeId {
                        contentItemIDs.append(id)
                    }
                }
            }
            worker.highPerformanceItems(from: contentItemIDs) { [unowned self] (items) in
                self.router.openMindsetShifterChecklist(trigger: trigger,
                                                        reactions: reactions,
                                                        lowPerformanceItems: lowItems,
                                                        highPerformanceItems: items)
            }
        }
    }

    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType) {
        router.openSolveResults(from: selectedAnswer, type: type)
    }

    func save(_ image: UIImage) {
        worker.save(image)
    }

    func openToBeVisionPage() {
        router.openToBeVisionPage()
    }

    func loadNextQuestion(from answer: QDMAnswer?) {
        worker.getNextQuestion(answer: answer) { [weak self] (node) in
            self?.showQuestion(node.question, node.generatedAnswer, animated: false)
        }
    }

    func loadNextQuestion(targetId: Int, animated: Bool) {
        worker.getNextQuestion(targetId: targetId) { [weak self] (node) in
            self?.showQuestion(node.question, node.generatedAnswer, animated: animated)
        }
    }

    private func showQuestion(_ question: QDMQuestion?, _ generatedAnswer: String? = nil, animated: Bool) {
        if let question = question {
            presenter.showQuestion(question,
                                   extraAnswer: generatedAnswer,
                                   filter: worker.answersFilter(),
                                   selectedAnswers: worker.selectedAnswers,
                                   direction: .forward,
                                   animated: animated)
        }
    }

    func showQuestion(_ question: QDMQuestion,
                      extraAnswer: String?,
                      filter: String?,
                      selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                      direction: UIPageViewController.NavigationDirection,
                      animated: Bool) {
        presenter.showQuestion(question,
                               extraAnswer: extraAnswer,
                               filter: filter,
                               selectedAnswers: selectedAnswers,
                               direction: direction,
                               animated: animated)
    }

    func handleSelection(for answer: QDMAnswer) {
        worker.handleSelection(for: answer)
    }

    func handleSingleSelection(for answer: QDMAnswer) {
        worker.handleSingleSelection(for: answer)
    }

    func didSelectAnswer(_ answer: QDMAnswer) {
        worker.didSelectAnswer(answer)
    }

    func didDeSelectAnswer(_ answer: QDMAnswer) {
        worker.didDeSelectAnswer(answer)
    }

    func setUserCalendarEvent(event: QDMUserCalendarEvent) {
        worker.setUserCalendarEvent(event: event)
    }

    func previousQuestion() -> QDMQuestion? {
        return worker.previousQuestion()
    }

    func didTapContinue() {
        worker.didTapContinue()
    }

    func didTapStartSprint() {
        worker.stopActiveSprintAndStartNewSprint()
    }

    func trackUserEvent(_ answer: QDMAnswer?, _ name: QDMUserEventTracking.Name, _ valueType: QDMUserEventTracking.ValueType?) {
        presenter.trackUserEvent(answer, name, valueType)
    }
    func dismiss() {
        presenter.dismiss()
    }

    func presentAddEventController(_ eventStore: EKEventStore) {
        presenter.presentAddEventController(eventStore)
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        presenter.presentInfoView(icon: icon, title: title, text: text)
    }

    func syncButtons(previousButtonIsHidden: Bool, continueButtonIsHidden: Bool, backgroundColor: UIColor) {
        presenter.syncButtons(previousButtonIsHidden: previousButtonIsHidden,
                              continueButtonIsHidden: continueButtonIsHidden,
                              backgroundColor: backgroundColor)
    }

    func updateBottomButtonTitle(counter: Int, maxSelections: Int, defaultTitle: String?, confirmTitle: String?) {
        presenter.updateBottomButtonTitle(counter: counter,
                                          maxSelections: maxSelections,
                                          defaultTitle: defaultTitle,
                                          confirmTitle: confirmTitle)
    }

    func bottomNavigationRightBarItems(action: Selector) -> [UIBarButtonItem]? {
        return worker.bottomNavigationRightBarItems(action: action)
    }

    func updateMultiSelectionCounter() {
        worker.updateMultiSelectionCounter()
    }

    func loadEventQuestion() {
        let eventQuestion = worker.eventQuestion
        self.loadNextQuestion(from: eventQuestion?.answers.first)
    }

    func toBeVisionDidChange() {
        router.openToBeVisionPage()
    }
}

// MARK: - Prepare
extension DecisionTreeInteractor {
    func openPrepareResults(_ contentId: Int) {
        router.openPrepareResults(contentId)
    }

    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer]) {
        router.openPrepareResults(preparation, answers)
    }

    func preparations() -> [QDMUserPreparation] {
        return worker.preparations
    }
}

// MARK: - Recovery
extension DecisionTreeInteractor {
    func updateRecoveryModel(fatigueAnswerId: Int, _ causeAnwserId: Int, _ targetContentId: Int) {
        worker.updateRecoveryModel(fatigueAnswerId: fatigueAnswerId, causeAnwserId, targetContentId)
    }

    func deleteModelIfNeeded() {
        worker.deleteModelIfNeeded()
    }

    func openRecoveryResults() {
        router.openRecoveryResults(worker.getRecoveryModel)
    }
}
