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
    func setupView()
    func showQuestion(_ question: QDMQuestion,
                      extraAnswer: String?,
                      filter: String?,
                      selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                      direction: UIPageViewController.NavigationDirection,
                      animated: Bool)
    func trackUserEvent(_ answer: QDMAnswer?,
                        _ name: QDMUserEventTracking.Name,
                        _ valueType: QDMUserEventTracking.ValueType?)
    func dismiss()
    func presentAddEventController(_ eventStore: EKEventStore)
    func syncButtons(previousButtonIsHidden: Bool, continueButtonIsHidden: Bool, backgroundColor: UIColor)
    func updateBottomButtonTitle(counter: Int, maxSelections: Int, defaultTitle: String?, confirmTitle: String?)
    func toBeVisionDidChange()
}

protocol DecisionTreePresenterInterface {
    func setupView()
    func showQuestion(_ question: QDMQuestion,
                      extraAnswer: String?,
                      filter: String?,
                      selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                      direction: UIPageViewController.NavigationDirection,
                      animated: Bool)
    func trackUserEvent(_ answer: QDMAnswer?,
                        _ name: QDMUserEventTracking.Name,
                        _ valueType: QDMUserEventTracking.ValueType?)
    func dismiss()
    func presentAddEventController(_ eventStore: EKEventStore)
    func syncButtons(previousButtonIsHidden: Bool, continueButtonIsHidden: Bool, backgroundColor: UIColor)
    func updateBottomButtonTitle(counter: Int, maxSelections: Int, defaultTitle: String?, confirmTitle: String?)
    func toBeVisionDidChange()
}

protocol DecisionTreeInteractorInterface: Interactor {
    var type: DecisionTreeType { get }
    var prepareBenefits: String? { get set }
    var relatedStrategyID: Int { get }
    var selectedanswers: [DecisionTreeModel.SelectedAnswer] { get }
    var answersFilter: String? { get }
    var extraAnswer: String? { get }
    func displayContent(with id: Int)
    func streamContentItem(with id: Int)
    func openImagePicker()
    func save(_ image: UIImage)
    func setTargetContentID(for answer: QDMAnswer)
    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer])
    func openPrepareResults(_ contentId: Int)
    func openRecoveryResults()
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType)
    func openToBeVisionPage()
    func openMindsetShifterChecklist(from answers: [QDMAnswer])
    func updatePrepareIntentions(_ answers: [DecisionTreeModel.SelectedAnswer])
    func updatePrepareBenefits(_ benefits: String)
    func updateRecoveryModel(fatigueAnswerId: Int, _ causeAnwserId: Int, _ targetContentId: Int)
    func deleteModelIfNeeded()
    func loadNextQuestion(from answer: QDMAnswer?)
    func loadNextQuestion(targetId: Int, animated: Bool)
    func loadEventQuestion()
    func handleSelection(for answer: QDMAnswer)
    func handleSingleSelection(for answer: QDMAnswer)
    func didSelectAnswer(_ answer: QDMAnswer)
    func didDeSelectAnswer(_ answer: QDMAnswer)
    func showQuestion(_ question: QDMQuestion,
                      extraAnswer: String?,
                      filter: String?,
                      selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                      direction: UIPageViewController.NavigationDirection,
                      animated: Bool)
    func previousQuestion() -> QDMQuestion?
    func didTapContinue()
    func trackUserEvent(_ answer: QDMAnswer?,
                        _ name: QDMUserEventTracking.Name,
                        _ valueType: QDMUserEventTracking.ValueType?)
    func setUserCalendarEvent(event: QDMUserCalendarEvent)
    func presentAddEventController(_ eventStore: EKEventStore)
    func syncButtons(previousButtonIsHidden: Bool, continueButtonIsHidden: Bool, backgroundColor: UIColor)
    func updateBottomButtonTitle(counter: Int, maxSelections: Int, defaultTitle: String?, confirmTitle: String?)
    func bottomNavigationRightBarItems(action: Selector) -> [UIBarButtonItem]?
    func updateMultiSelectionCounter()
    func toBeVisionDidChange()
    func dismiss()
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
    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType)
    func openToBeVisionPage()
    func openRecoveryResults(_ recovery: QDMRecovery3D?)
}

protocol DecisionTreeModelInterface {
    mutating func reset()
    mutating func removeLastQuestion()
    mutating func add(_ question: QDMQuestion)
    mutating func remove(_ question: QDMQuestion)
    mutating func add(_ selection: DecisionTreeModel.SelectedAnswer)
    mutating func remove(_ selection: DecisionTreeModel.SelectedAnswer)
}
