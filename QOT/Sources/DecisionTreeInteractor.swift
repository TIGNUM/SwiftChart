//
//  DecisionTreeInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

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
        if let firstQuestion = worker.fetchFirstQuestion() {
            let decisionTree = DecisionTreeModel(questions: [firstQuestion], selectedAnswers: [])
            presenter.load(decisionTree)
        }
    }
}

// MARK: - DecisionTreeInteractorInterface

extension DecisionTreeInteractor: DecisionTreeInteractorInterface {
    var userHasToBeVision: Bool {
        return worker.userHasToBeVision
    }

    var relatedStrategyID: Int {
        return worker.targetContentID
    }

    var selectedanswers: [DecisionTreeModel.SelectedAnswer] {
        return worker.selectedAnswers
    }

    var prepareBenefits: String? {
        set {
            worker.prepareBenefits = newValue
        }
        get {
            return worker.prepareBenefits
        }
    }

    var type: DecisionTreeType {
        return worker.type
    }

    func setTargetContentID(for answer: Answer) {
        worker.setTargetContentID(for: answer)
    }

    func answersFilter(currentQuestion: Question?, decisionTree: DecisionTreeModel?) -> String? {
        return worker.answersFilter(currentQuestion: currentQuestion, decisionTree: decisionTree)
    }

    func loadNextQuestion(from targetID: Int, selectedAnswers: [Answer]) {
        let node = worker.fetchNextQuestion(from: targetID, selectedAnswers: selectedAnswers)
        if let question = node.question {
            presenter.presentNext(question, with: node.generatedAnswer)
        }
    }

    func openPrepareChecklist(with contentID: Int,
                              selectedEvent: CalendarEvent?,
                              eventType: String?,
                              checkListType: PrepareCheckListType,
                              relatedStrategyID: Int?,
                              selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                              benefits: String?) {
        router.openPrepareChecklist(with: contentID,
                                    checkListType: checkListType,
                                    selectedEvent: selectedEvent,
                                    eventType: eventType,
                                    relatedStrategyID: relatedStrategyID,
                                    selectedAnswers: selectedAnswers,
                                    benefits: benefits)
    }

    func displayContent(with id: Int) {
        router.openArticle(with: id)
    }

    func streamContentItem(with id: Int) {
        if let url = worker.mediaURL(from: id) {
            router.openVideo(from: url)
        }
    }

    func openImagePicker() {
        router.openImagePicker()
    }

    func notifyCounterChanged(with value: Int, selectedAnswers: [Answer]) {
        let selectionCounter = UserInfo.multiSelectionCounter.pair(for: value)
        let selectedAnswers = UserInfo.selectedAnswers.pair(for: selectedAnswers)
        NotificationCenter.default.post(name: .multiSelectionCounter,
                                        object: nil,
                                        userInfo: [selectionCounter.key: selectionCounter.value,
                                                   selectedAnswers.key: selectedAnswers.value])
    }

    func openShortTBVGenerator() {
        if worker.userHasToBeVision == false {
            router.openShortTBVGenerator()
        }
    }

    func openMindsetShifterChecklist(from answers: [Answer]) {
        if let trigger = answers.first(where: { $0.keys.filter { $0.contains("trigger-") }.isEmpty == false })?.title {
            let reactions = answers.filter { $0.keys.filter { $0.contains("reaction") }.isEmpty == false }.map { $0.title }
            let lowItems = answers.filter { $0.keys.filter { $0.contains("lowperformance") }.isEmpty == false }.map { $0.title }
            var contentItemIDs: [Int] = []
            answers.forEach {
                $0.decisions.forEach {
                    if $0.targetType == TargetType.contentItem.rawValue, let id = $0.targetID {
                        contentItemIDs.append(id)
                    }
                }
            }
            router.openMindsetShifterChecklist(trigger: trigger,
                                               reactions: reactions,
                                               lowPerformanceItems: lowItems,
                                               highPerformanceItems: worker.highPerformanceItems(from: contentItemIDs))
        }
    }

    func openSolveResults(from selectedAnswer: Answer) {
        router.openSolveResults(from: selectedAnswer)
    }

    func save(_ image: UIImage) {
        worker.save(image)
    }

    func openToBeVisionPage() {
        router.openToBeVisionPage()
    }
}
