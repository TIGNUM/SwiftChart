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
    func openTools(toolID: Int?)

    func presentStrategyList(strategyID: Int?)

    func showSolveResults(solve: QDMSolve)

    func showCustomizeTarget()

    func saveAnswerValue(_ value: Int, from cell: UITableViewCell)

    func saveTargetValue(value: Int?)

    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?)

    func presentPrepareResults(for preparation: QDMUserPreparation?)

    func presentPopUp(copyrightURL: String?, description: String?)

    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?)

    func reloadSprintCell(cell: UITableViewCell)

    func didUpdateLevel5()

    func displayCoachPreparationScreen()

    func openGuidedTrackAppLink(_ appLink: QDMAppLink?)

    func presentMyDataScreen()

    func didChangeLocationPermission(granted: Bool)

    func showDailyCheckInQuestions()

    func showAlert(message: String?)

    func showBanner(message: String)

    func showTBV()

    func showTeamTBV(_ team: QDMTeam)

    func didSelectDeclineTeamInvite(invitation: QDMTeamInvitation)

    func didSelectJoinTeamInvite(invitation: QDMTeamInvitation)

    func presentTeamPendingInvites()
}

protocol DailyBriefViewControllerInterface: class {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>)
    func scrollToSection(at: Int)
}

protocol DailyBriefPresenterInterface {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>)
    func scrollToSection(at: Int)
}

protocol DailyBriefInteractorInterface: Interactor {
    var rowViewSectionCount: Int { get }

    func bucket(at row: Int) -> QDMDailyBriefBucket?
    func bucketViewModelNew() -> [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]?
    func getDailyBriefBucketsForViewModel()
    func getToBeVisionImage(completion: @escaping (URL?) -> Void)
    func getTeamTBVPoll(for team: QDMTeam, _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)

    func startTimer(forCell: BaseDailyBriefCell, at indexPath: IndexPath)
    func invalidateTimer(forCell: BaseDailyBriefCell)

    func saveAnswerValue(_ value: Int)
    func saveTargetValue(value: Int?)
    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func updateViewModelListNew(_ list: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>])
    func updateDailyBriefBucket()
    func didSelectDeclineTeamInvite(invitation: QDMTeamInvitation)
    func didSelectJoinTeamInvite(invitation: QDMTeamInvitation)

    func markAsRead(teamNewsFeed: QDMTeamNewsFeed?, _ completion: @escaping() -> Void)
}

protocol DailyBriefRouterInterface: BaseRouterInterface {
    func presentCustomizeTarget(_ data: RatingQuestionViewModel.Question?)
    func presentPopUp(copyrightURL: String?, description: String?)
    func presentSolveResults(solve: QDMSolve)
    func presentPrepareResults(for preparation: QDMUserPreparation?)
    func presentDailyCheckInQuestions()
    func presentCoachPreparation()
    func presentMindsetResults(_ mindsetShifter: QDMMindsetShifter?)
    func showMyDataScreen()
    func presentTeamPendingInvites()
    func launchAppLinkGuidedTrack(_ appLink: QDMAppLink?)
}
