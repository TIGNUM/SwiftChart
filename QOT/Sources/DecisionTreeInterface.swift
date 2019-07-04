//
//  DecisionTreeInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

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
    var toBeVisionText: String? { get }
    func notifyCounterChanged(with value: Int, selectedAnswers: [Answer])
    func loadNextQuestion(from targetID: Int, selectedAnswers: [Answer])
    func displayContent(with id: Int)
    func streamContentItem(with id: Int)
    func openImagePicker()
    func save(_ image: UIImage)
    func answersFilter(currentQuestion: Question?, decisionTree: DecisionTreeModel?) -> String?
    func setTargetContentID(for answer: Answer)
    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer])
    func openPrepareResults(_ contentId: Int)
    func openRecoveryResults()
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openSolveResults(from selectedAnswer: Answer, type: ResultType)
    func openToBeVisionPage()
    func openMindsetShifterChecklist(from answers: [Answer])
    func updatePrepareIntentions(_ answers: [DecisionTreeModel.SelectedAnswer])
    func updatePrepareBenefits(_ benefits: String)
    func updateRecoveryModel(fatigueAnswerId: Int, _ causeAnwserId: Int, _ targetContentId: Int)
    func deleteModelIfNeeded()
}

protocol DecisionTreeRouterInterface {
    func openPrepareResults(_ contentId: Int)
    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer])
    func openMindsetShifterChecklist(trigger: String,
                                     reactions: [String],
                                     lowPerformanceItems: [String],
                                     highPerformanceItems: [String])
    func openArticle(with contentID: Int)
    func openVideo(from url: URL)
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openImagePicker()
    func openSolveResults(from selectedAnswer: Answer, type: ResultType)
    func openToBeVisionPage()
    func openRecoveryResults(_ recovery: QDMRecovery3D?)
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
    func fetchNextQuestion(from targetID: Int, selectedAnswers: [Answer]) -> DecisionTreeNode
    func mediaURL(from contentItemID: Int) -> URL?
    func fetchFirstQuestion() -> Question?
    func save(_ image: UIImage)
}
