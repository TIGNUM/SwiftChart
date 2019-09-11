//
//  DecisionTreeInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import UserNotifications

final class DecisionTreeInteractor {

    // MARK: - Properties
    private var worker: DecisionTreeWorker?
    private let presenter: DecisionTreePresenterInterface
    private let router: DecisionTreeRouterInterface

    // MARK: - Init
    init(type: DecisionTreeType,
         presenter: DecisionTreePresenterInterface,
         router: DecisionTreeRouterInterface) {
        self.presenter = presenter
        self.router = router
        worker = DecisionTreeWorker(type: type)
        worker?.interactor = self
        worker?.fetchToBeVision()
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        if let type = worker?.type, case .sprint = type {
            checkNotificationPermissions()
        }
        fetchFirstQuestionAndDisplay()
    }
}

private extension DecisionTreeInteractor {
    func fetchFirstQuestionAndDisplay() {
        worker?.fetchQuestions { [weak self] in
            if let question = self?.worker?.firstQuestion {
                self?.showQuestion(question, animated: true)
            }
        }
    }
}

// MARK: - DecisionTreeInteractorInterface
extension DecisionTreeInteractor: DecisionTreeInteractorInterface {
    var selectedanswers: [DecisionTreeModel.SelectedAnswer] {
        return worker?.selectedAnswers ?? []
    }

    var userInput: String? {
        set { worker?.userInput = newValue }
        get { return worker?.userInput }
    }

    var type: DecisionTreeType {
        return worker?.type ?? .toBeVisionGenerator
    }

    var answersFilter: String? {
        return worker?.answersFilter()
    }

    var extraAnswer: String? {
        return worker?.extraAnswer
    }

    var selectedSprintTitle: String {
        return worker?.selectedSprintTitle ?? ""
    }

    var selectedSprint: QDMAnswer? {
        return worker?.selectedSprint
    }

    var pageDisplayed: Int {
        return worker?.pageIndex ?? 0
    }

    var createdToBeVision: QDMToBeVision? {
        return worker?.createdTBV
    }

    var multiSelectionCounter: Int {
        return worker?.multiSelectionCounter ?? 0
    }

    var hasLeftBarButtonItem: Bool {
        if case .mindsetShifterTBVOnboarding = type {
            return false
        }
        switch worker?.currentQuestion?.key {
        case QuestionKey.Sprint.Last?: return false
        default: return true
        }
    }

    var multiSectionButtonArguments: (title: String, textColor: UIColor, bgColor: UIColor, enabled: Bool) {
        let selectedAnswersCount = worker?.multiSelectionCounter ?? 0
        let maxSelections = worker?.maxPossibleSelections ?? 0
        let currentValue = maxSelections - selectedAnswersCount
        let title = R.string.localized.buttonTitlePick(currentValue)
        let textColor: UIColor = selectedAnswersCount < maxSelections ? .carbonDark30 : .accent
        let backgroundColor: UIColor = selectedAnswersCount < maxSelections ? .carbonDark08 : .carbon
        let enabled = selectedAnswersCount == maxSelections
        return (title, textColor, backgroundColor, enabled)
    }

    func displayContent(with id: Int) {
        router.openArticle(with: id)
    }

    func streamContentItem(with id: Int) {
        worker?.mediaURL(from: id) { [weak self] (url, item) in
            if let url = url {
                self?.router.openVideo(from: url, item: item)
            }
        }
    }

    func openImagePicker() {
        router.openImagePicker()
    }

    func openShortTBVGenerator(completion: (() -> Void)?) {
        if worker?.userHasToBeVision == false {
            router.openShortTBVGenerator(completion: completion)
        }
    }

    func openMindsetShifterResult(resultItem: MindsetResult.Item, completion: @escaping () -> Void) {
        router.openMindsetShifterResult(resultItem: resultItem, completion: completion)
    }

    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType) {
        router.openSolveResults(from: selectedAnswer, type: type)
    }

    func save(_ image: UIImage) {
        worker?.save(image)
    }

    func openToBeVisionPage() {
        router.openToBeVisionPage()
    }

    func loadNextQuestion(from answer: QDMAnswer?) {
        worker?.getNextQuestion(answer: answer) { [weak self] (node) in
            self?.showQuestion(node.question, node.generatedAnswer, animated: false)
        }
    }

    func loadNextQuestion(targetId: Int, animated: Bool) {
        worker?.getNextQuestion(targetId: targetId) { [weak self] (node) in
            self?.showQuestion(node.question, node.generatedAnswer, animated: animated)
        }
    }

    private func showQuestion(_ question: QDMQuestion?, _ generatedAnswer: String? = nil, animated: Bool) {
        if let question = question {
            presenter.showQuestion(question,
                                   extraAnswer: generatedAnswer,
                                   filter: worker?.answersFilter(),
                                   selectedAnswers: worker?.selectedAnswers ?? [],
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

    func handleSingleSelection(for answer: QDMAnswer) {
        worker?.handleSingleSelection(for: answer)
    }

    func didSelectAnswer(_ answer: QDMAnswer) {
        worker?.didSelectAnswer(answer)
    }

    func didDeSelectAnswer(_ answer: QDMAnswer) {
        worker?.didDeSelectAnswer(answer)
    }

    func setUserCalendarEvent(event: QDMUserCalendarEvent) {
        worker?.setUserCalendarEvent(event: event)
    }

    func previousQuestion() -> QDMQuestion? {
        return worker?.previousQuestion()
    }

    func didTapContinue() {
        worker?.didTapContinue()
    }

    func didTapStartSprint() {
        worker?.stopActiveSprintAndStartNewSprint()
    }

    func trackUserEvent(_ answer: QDMAnswer?, _ name: QDMUserEventTracking.Name, _ valueType: QDMUserEventTracking.ValueType?) {
        presenter.trackUserEvent(answer, name, valueType)
    }
    func dismiss() {
        presenter.dismiss()
        worker = nil
    }

    func dismissAll() {
        router.dismissAll()
        worker = nil
    }

    func presentAddEventController(_ eventStore: EKEventStore) {
        presenter.presentAddEventController(eventStore)
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        presenter.presentInfoView(icon: icon, title: title, text: text)
    }

    func updateMultiSelectionCounter() {
        worker?.updateMultiSelectionCounter()
    }

    func loadEventQuestion() {
        let eventQuestion = worker?.eventQuestion
        self.loadNextQuestion(from: eventQuestion?.answers.first)
    }

    func toBeVisionDidChange() {
        router.openToBeVisionPage()
    }

    func dismissAndGoToMyQot() {
       router.dismissAndGoToMyQot()
    }

    func getCalendarPermissionType() -> AskPermission.Kind? {
        return worker?.getCalendarPermissionType()
    }

    func presentPermissionView(_ permissionType: AskPermission.Kind) {
        router.presentPermissionView(permissionType)
    }
}

// MARK: - Prepare
extension DecisionTreeInteractor {
    func openPrepareResults(_ contentId: Int) {
        router.openPrepareResults(contentId)
        worker = nil
    }

    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer]) {
        router.openPrepareResults(preparation, answers)
        worker = nil
    }

    func preparations() -> [QDMUserPreparation] {
        return worker?.preparations ?? []
    }
}

// MARK: - Recovery
extension DecisionTreeInteractor {
    func updateRecoveryModel(fatigueContentItemId: Int, _ causeAnwserId: Int, _ targetContentId: Int) {
        worker?.updateRecoveryModel(fatigueContentItemId: fatigueContentItemId, causeAnwserId, targetContentId)
    }

    func deleteModelIfNeeded() {
        worker?.deleteModelIfNeeded()
    }

    func openRecoveryResults() {
        worker?.createRecoveryModel { [weak self] (recovery) in
            self?.router.openRecoveryResults(recovery)
        }
    }
}

// MARK: - Private methods

private extension DecisionTreeInteractor {
    func checkNotificationPermissions() {
        RemoteNotificationPermission().authorizationStatus { [weak self] (status) in
            switch status {
            case .denied:
                self?.router.presentPermissionView(.notificationOpenSettings)
            case .notDetermined:
                self?.router.presentPermissionView(.notification)
            case .authorized, .provisional:
                break
            }
        }
    }
}
