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
    func notifyCounterChanged(with value: Int, selectedAnswers: [Answer])
    func loadNextQuestion(from targetID: Int, selectedAnswers: [Answer])
    func displayContent(with id: Int)
    func streamContentItem(with id: Int)
    func uploadPhoto()
}

protocol DecisionTreeRouterInterface {
    func openArticle(with contentID: Int)
    func openVideo(from url: URL)
    func openImagePicker()
}

protocol DecisionTreeModelInterface {
    mutating func add(_ question: Question)
    mutating func addOrRemove(_ selection: DecisionTreeModel.SelectedAnswer, addCompletion: () -> Void, removeCompletion: () -> Void)
    mutating func remove(_ question: Question)
    mutating func removeLastQuestion()
    mutating func reset()
}
