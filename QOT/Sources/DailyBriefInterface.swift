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

enum MyPeakPerformanceBucketType: String, CaseIterable {
    case IN_THREE_DAYS
    case TOMORROW
    case TODAY
    case REFLECT
}

protocol DailyBriefViewControllerDelegate: class {
    func presentStrategyList(strategyID: Int?)

    func showSolveResults(solve: QDMSolve)

    func saveTargetValue(value: Int?)

    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?)

    func presentPrepareResults(for preparation: QDMUserPreparation?)

    func presentPopUp(copyrightURL: String?, description: String?)

    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?)

    func displayCoachPreparationScreen()

    func showDailyCheckInQuestions()

    func showAlert(message: String?)

    func showBanner(message: String)

    func showTBV()

    func showTeamTBV(_ team: QDMTeam)

    func didSelectDeclineTeamInvite(invitation: QDMTeamInvitation)

    func didSelectJoinTeamInvite(invitation: QDMTeamInvitation)

    func presentTeamPendingInvites()

    func presentToBeVisionPoll(for team: QDMTeam)

    func presentToBeVisionRate(for team: QDMTeam)

    func showRateHistory(for team: QDMTeam)
}

protocol DailyBriefViewControllerInterface: class {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>]>)
    func scrollToSection(at: Int)
}

protocol DailyBriefPresenterInterface {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>]>)
    func scrollToSection(at: Int)
}

protocol DailyBriefInteractorInterface: Interactor {
    var rowViewSectionCount: Int { get }

    func bucket(at row: Int) -> QDMDailyBriefBucket?
    func bucketViewModelNew() -> [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>]?
    func getDailyBriefBucketsForViewModel()
    func getToBeVisionImage(completion: @escaping (URL?) -> Void)
    func getTeamTBVPoll(for team: QDMTeam, _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)
    func startTimer(forCell: BaseDailyBriefCell, at indexPath: IndexPath)
    func invalidateTimer(forCell: BaseDailyBriefCell)

    func saveTargetValue(value: Int?)
    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func updateViewModelListNew(_ list: [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>])
    func updateDailyBriefBucket()
    func didSelectDeclineTeamInvite(invitation: QDMTeamInvitation)
    func didSelectJoinTeamInvite(invitation: QDMTeamInvitation)

    func markAsRead(teamNewsFeed: QDMTeamNewsFeed?, _ completion: @escaping() -> Void)
    func setDetailsDelegate(_ delegate: BaseDailyBriefDetailsViewControllerInterface)
}

protocol DailyBriefRouterInterface: BaseRouterInterface {
    func presentPopUp(copyrightURL: String?, description: String?)
    func presentSolveResults(solve: QDMSolve)
    func presentPrepareResults(for preparation: QDMUserPreparation?)
    func presentDailyCheckInQuestions()
    func presentCoachPreparation()
    func presentMindsetResults(_ mindsetShifter: QDMMindsetShifter?)
    func presentTeamPendingInvites()
    func showExplanation(_ team: QDMTeam, type: Explanation.Types)
}
