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
    func notifyCounterChanged(with value: Int, selectedAnswers: [Answer])
    func loadNextQuestion(from targetID: Int, selectedAnswers: [Answer])
    func openPrepareChecklist(with contentID: Int)
    func displayContent(with id: Int)
    func openMindsetShifterChecklist(from answers: [Answer])
    func streamContentItem(with id: Int)
    func openShortTBVGenerator()
    func openImagePicker()
    func save(_ image: UIImage)
}

protocol DecisionTreeRouterInterface {
    func openPrepareChecklist(with contentID: Int)
    func openMindsetShifterChecklist(trigger: String, reactions: [String], lowPerformanceItems: [String])
    func openArticle(with contentID: Int)
    func openVideo(from url: URL)
    func openShortTBVGenerator()
    func openImagePicker()
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
