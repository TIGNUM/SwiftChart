//
//  DecisionTreeInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol DecisionTreeViewControllerInterface: class {
    func load(_ decisionTree: DecisionTreeModel)
    func loadNext(_ question: Question, with extraAnswer: String?)
}

protocol DecisionTreePresenterInterface {
    func load(_ decisionTree: DecisionTreeModel)
    func presentNext(_ question: Question, with extraAnswer: String?)
}

protocol DecisionTreeInteractorInterface: Interactor {
    var type: DecisionTreeType { get }
    var prepareBenefits: String? { get set }
    var relatedStrategyID: Int { get }
    var selectedanswers: [DecisionTreeModel.SelectedAnswer] { get }
    var userHasToBeVision: Bool { get }
    func notifyCounterChanged(with value: Int, selectedAnswers: [Answer])
    func loadNextQuestion(from targetID: Int, selectedAnswers: [Answer])
    func openPrepareChecklist(with contentID: Int,
                              selectedEvent: CalendarEvent?,
                              eventType: String?,
                              checkListType: PrepareCheckListType,
                              relatedStrategyID: Int?,
                              selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                              benefits: String?)
    func displayContent(with id: Int)
    func openMindsetShifterChecklist(from answers: [Answer])
    func streamContentItem(with id: Int)
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openImagePicker()
    func save(_ image: UIImage)
    func answersFilter(currentQuestion: Question?, decisionTree: DecisionTreeModel?) -> String?
    func openSolveResults(from selectedAnswer: Answer)
    func openToBeVisionPage()
    func setTargetContentID(for answer: Answer)
}

protocol DecisionTreeRouterInterface {
    func openPrepareChecklist(with contentID: Int,
                              checkListType: PrepareCheckListType,
                              selectedEvent: CalendarEvent?,
                              eventType: String?,
                              relatedStrategyID: Int?,
                              selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                              benefits: String?)
    func openMindsetShifterChecklist(trigger: String,
                                     reactions: [String],
                                     lowPerformanceItems: [String],
                                     highPerformanceItems: [String])
    func openArticle(with contentID: Int)
    func openVideo(from url: URL)
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openImagePicker()
    func openSolveResults(from selectedAnswer: Answer)
    func openToBeVisionPage()
}

protocol DecisionTreeModelInterface {
    mutating func reset()
    mutating func removeLastQuestion()
    mutating func add(_ question: Question)
    mutating func remove(_ question: Question)
    mutating func addOrRemove(_ selection: DecisionTreeModel.SelectedAnswer,
                              addCompletion: () -> Void,
                              removeCompletion: () -> Void)
}

protocol DecisionTreeWorkerInterface {
    var userHasToBeVision: Bool { get }
    func fetchNextQuestion(from targetID: Int, selectedAnswers: [Answer]) -> DecisionTreeNode
    func mediaURL(from contentItemID: Int) -> URL?
    func fetchFirstQuestion() -> Question?
    func save(_ image: UIImage)
}
