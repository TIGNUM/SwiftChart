//
//  DecisionTreeInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DecisionTreeViewControllerInterface: UIViewController, ScreenZLevel3 {
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
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
    func toBeVisionDidChange()
    func presentPermissionView(_ permissionType: AskPermission.Kind)
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
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
    func toBeVisionDidChange()
}

protocol DecisionTreeInteractorInterface: Interactor {
    var type: DecisionTreeType { get }
    var hasLeftBarButtonItem: Bool {  get }
    var userInput: String? { get set }
    var selectedanswers: [DecisionTreeModel.SelectedAnswer] { get }
    var answersFilter: String? { get }
    var extraAnswer: String? { get }
    var selectedSprintTitle: String { get }
    var selectedSprint: QDMAnswer? { get }
    var pageDisplayed: Int { get }
    var createdToBeVision: QDMToBeVision? { get }
    var multiSelectionCounter: Int { get }
    var multiSectionButtonArguments: (title: String, textColor: UIColor, bgColor: UIColor, enabled: Bool) { get }

    func preparations() -> [QDMUserPreparation]
    func displayContent(with id: Int)
    func streamContentItem(with id: Int)
    func openImagePicker()
    func save(_ image: UIImage)

    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer])
    func openPrepareResults(_ contentId: Int)
    func openRecoveryResults()
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType)
    func openToBeVisionPage()
    func openMindsetShifterResult(resultItem: MindsetResult.Item, completion: @escaping () -> Void)
    func dismissAndGoToMyQot()

    func updateRecoveryModel(fatigueContentItemId: Int, _ causeAnwserId: Int, _ targetContentId: Int)
    func deleteModelIfNeeded()
    func loadNextQuestion(from answer: QDMAnswer?)
    func loadNextQuestion(targetId: Int, animated: Bool)
    func loadEventQuestion()
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
    func didTapStartSprint()
    func trackUserEvent(_ answer: QDMAnswer?,
                        _ name: QDMUserEventTracking.Name,
                        _ valueType: QDMUserEventTracking.ValueType?)
    func setUserCalendarEvent(event: QDMUserCalendarEvent)
    func presentAddEventController(_ eventStore: EKEventStore)
    func presentInfoView(icon: UIImage?, title: String?, text: String?)
    func updateMultiSelectionCounter()
    func toBeVisionDidChange()
    func dismiss()
    func getCalendarPermissionType() -> AskPermission.Kind?
    func presentPermissionView(_ permissionType: AskPermission.Kind)
    func dismissAll()
}

protocol DecisionTreeRouterInterface {
    func openPrepareResults(_ contentId: Int)
    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer])
    func openMindsetShifterResult(resultItem: MindsetResult.Item, completion: @escaping () -> Void)
    func openArticle(with contentID: Int)
    func openVideo(from url: URL, item: QDMContentItem?)
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openImagePicker()
    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType)
    func openToBeVisionPage()
    func openRecoveryResults(_ recovery: QDMRecovery3D?)
    func dismissAndGoToMyQot()
    func dismissAll()
    func presentPermissionView(_ permissionType: AskPermission.Kind)
}

protocol DecisionTreeModelInterface {
    mutating func reset()
    mutating func removeLastQuestion()
    mutating func add(_ question: QDMQuestion)
    mutating func update(_ question: QDMQuestion?, _ userInput: String?)
    mutating func remove(_ extendedQuestion: DecisionTreeModel.ExtendedQuestion)
    mutating func add(_ selection: DecisionTreeModel.SelectedAnswer)
    mutating func remove(_ selection: DecisionTreeModel.SelectedAnswer)
}
