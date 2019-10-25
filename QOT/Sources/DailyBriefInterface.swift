//
//  DailyBriefInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import DifferenceKit

protocol DailyBriefViewControllerInterface: class {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>)
}

protocol DailyBriefPresenterInterface {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>)
}

protocol DailyBriefInteractorInterface: Interactor {
    var rowViewModelCount: Int { get }
    var rowViewSectionCount: Int { get }
    var shpiAnswer: QDMDailyCheckInAnswer? { get }
    var peakPerformanceCount: Int? { get }

    func bucket(at row: Int) -> QDMDailyBriefBucket?
    func bucketViewModel(at row: Int) -> BaseDailyBriefViewModel?
    func bucketViewModelNew() -> [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]?
    func getDailyBriefBucketsForViewModel()
    func getToBeVisionImage(completion: @escaping (URL?) -> Void)

    func presentMyDataScreen()
    func presentWhatsHotArticle(selectedID: Int)
    func presentMyToBeVision()
    func presentStrategyList(selectedStrategyID: Int)
    func presentToolsItems(selectedToolID: Int?)
    func presentCopyRight(copyrightURL: String?)
    func openGuidedTrackAppLink(_ appLink: QDMAppLink?)
    func showSolveResults(solve: QDMSolve)
    func showCustomizeTarget()
    func displayCoachPreparationScreen()
    func didPressGotItSprint(sprint: QDMSprint)
    func startTimer(forCell: BaseDailyBriefCell, at indexPath: IndexPath)
    func invalidateTimer(forCell: BaseDailyBriefCell)

    func saveAnswerValue(_ value: Int)
    func saveUpdatedDailyCheckInSleepTarget(_ value: Double)
    func saveTargetValue(value: Int?)
    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func updateViewModelListNew(_ list: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>])
    func updateDailyBriefBucket()
    func showDailyCheckInQuestions()
}

protocol DailyBriefRouterInterface {
    func presentWhatsHotArticle(selectedID: Int)
    func presentMyToBeVision()
    func showCustomizeTarget(_ data: RatingQuestionViewModel.Question?)
    func presentStrategyList(selectedStrategyID: Int)
    func presentToolsItems(selectedToolID: Int?)
    func showSolveResults(solve: QDMSolve)
    func presentCopyRight(copyrightURL: String?)
    func displayCoachPreparationScreen()
    func openGuidedTrackAppLink(_ appLink: QDMAppLink?)
    func presentMyDataScreen()
    func showDailyCheckInQuestions()
}
