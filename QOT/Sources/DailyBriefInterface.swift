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
    func scrollToSection(at: Int)
}

protocol DailyBriefPresenterInterface {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>)
    func scrollToSection(at: Int)
    func showSprintCompletedAlert()
}

protocol DailyBriefInteractorInterface: Interactor {
    var rowViewSectionCount: Int { get }

    func bucket(at row: Int) -> QDMDailyBriefBucket?
    func bucketViewModelNew() -> [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]?
    func getDailyBriefBucketsForViewModel()
    func getToBeVisionImage(completion: @escaping (URL?) -> Void)

    func didPressGotItSprint(sprint: QDMSprint)
    func startTimer(forCell: BaseDailyBriefCell, at indexPath: IndexPath)
    func invalidateTimer(forCell: BaseDailyBriefCell)

    func saveAnswerValue(_ value: Int)
    func saveTargetValue(value: Int?)
    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func updateViewModelListNew(_ list: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>])
    func updateDailyBriefBucket()
}

protocol DailyBriefRouterInterface {
    func presentCustomizeTarget(_ data: RatingQuestionViewModel.Question?)
    func presentStrategyList(strategyID: Int?)
    func presentToolsItems(toolID: Int?)
    func presentWhatsHotArticle(articleID: Int?)
    func presentCopyRight(copyrightURL: String?)
    func presentSolveResults(solve: QDMSolve)
    func presentPrepareResults(for preparation: QDMUserPreparation?)
    func presentDailyCheckInQuestions()
    func presentCoachPreparation()

    func showMyToBeVision()
    func showMyDataScreen()

    func launchAppLinkGuidedTrack(_ appLink: QDMAppLink?)
}
