//
//  TeamToBeVisionInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionInteractor {

    // MARK: - Properties
    private lazy var worker = TeamToBeVisionWorker()
    let router: TeamToBeVisionRouter
    private let presenter: TeamToBeVisionPresenterInterface!
    var team: QDMTeam?
    var teamVision: QDMTeamToBeVision?
    private var downSyncObserver: NSObjectProtocol?
    private var upSyncObserver: NSObjectProtocol?

    // MARK: - Init
    init(presenter: TeamToBeVisionPresenterInterface, router: TeamToBeVisionRouter, team: QDMTeam?) {
        self.presenter = presenter
        self.router = router
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        presenter.setSelectionBarButtonItems()
        didUpdateTBVRelatedData()
        let notificationCenter = NotificationCenter.default
        downSyncObserver = notificationCenter.addObserver(forName: .didFinishSynchronization, object: nil, queue: nil) { [weak self ] (notification) in
            guard let strongSelf = self else {
                return
            }
            guard let syncResult = notification.object as? SyncResultContext,
                syncResult.syncRequestType == .DOWN_SYNC,
                syncResult.hasUpdatedContent else { return }
            switch syncResult.dataType {
            case .TEAM_TO_BE_VISION:
                strongSelf.didUpdateTBVRelatedData()
            default:
                break
            }
        }
        upSyncObserver = notificationCenter.addObserver(forName: .requestSynchronization, object: nil, queue: nil) { [weak self ] (notification) in
            guard let strongSelf = self else {
                return
            }
            guard let syncResult = notification.object as? SyncRequestContext else { return }
            if syncResult.dataType == .TEAM_TO_BE_VISION,
                syncResult.syncRequestType == .UP_SYNC {
                strongSelf.didUpdateTBVRelatedData()
            }
        }
    }

    func viewWillAppear() {
        didUpdateTBVRelatedData()
    }

    private func didUpdateTBVRelatedData() {
        guard let team = team else { return }
        worker.getTeamToBeVision(for: team) { [weak self] (teamVision) in
            self?.teamVision = teamVision
            self?.presenter.load(teamVision,
                                 rateText: "",
                                 isRateEnabled: false)
        }
    }
}

// MARK: - TeamToBeVisionInteractorInterface
extension TeamToBeVisionInteractor: TeamToBeVisionInteractorInterface {

    func showEditVision(isFromNullState: Bool) {
        guard let team = team else { return }
        worker.getTeamToBeVision(for: team) { (teamVision) in
            self.router.showEditVision(title: teamVision?.headline ?? "",
                                       vision: teamVision?.text ?? "",
                                       isFromNullState: isFromNullState,
                                       team: team)
        }
    }

    func showNullState(with title: String, teamName: String?, message: String) {
        presenter.showNullState(with: title, teamName: teamName, message: message)
    }

    func hideNullState() {
        presenter.hideNullState()
    }

    func isShareBlocked(_ completion: @escaping (Bool) -> Void) {
        guard let team = team else { return }
        worker.getTeamToBeVision(for: team) { (teamVision) in
            completion(teamVision?.headline == nil && teamVision?.text == nil)
        }
    }

    func saveToBeVision(image: UIImage?) {
        guard let team = team else { return }
        worker.getTeamToBeVision(for: team) { [weak self] (teamVision) in
            if var teamVision = teamVision {
                teamVision.modifiedAt = Date()
                if let teamVisionImage = image {
                    do {
                        let imageUrl = try self?.worker.saveImage(teamVisionImage).absoluteString
                        teamVision.profileImageResource = QDMMediaResource()
                        teamVision.profileImageResource?.localURLString = imageUrl
                    } catch {
                        log(error.localizedDescription)
                    }
                } else {
                    teamVision.profileImageResource = nil
                }
                self?.worker.updateTeamToBeVision(teamVision, team: team) { [weak self] (responseTeamVision) in
                    self?.didUpdateTBVRelatedData()
                }
            }
        }
    }

    func presentTrends() {
        // TODO
    }

    var nullStateCTA: String? {
        worker.nullStateTeamCTA
    }

    var teamNullStateSubtitle: String? {
        return worker.teamNullStateSubtitle
    }

    var teamNullStateTitle: String? {
        return worker.teamNullStateTitle
    }

    var emptyTeamTBVTitlePlaceholder: String {
        return worker.emptyTeamTBVTitlePlaceholder
    }

    var emptyTeamTBVTextPlaceholder: String {
        return worker.emptyTeamTBVTextPlaceholder
    }

    func lastUpdatedTeamVision() -> String? {
        var lastUpdatedVision = ""
        guard let date = teamVision?.date?.beginingOfDate() else { return ""}
        let days = DateComponentsFormatter.numberOfDays(date)
        lastUpdatedVision = self.dateString(for: days)
        return lastUpdatedVision
    }

    func hasOpenVisionRatingPoll(_ completion: @escaping (Bool) -> Void) {
        guard let team = team else { return }
        worker.hasOpenRatingPoll(for: team, completion)
    }

    func ratingTapped() {
        hasOpenVisionRatingPoll {(open) in
            guard let isOwner = self.team?.thisUserIsOwner else { return }
            if open, isOwner {
                self.router.showAdminOptions(team: self.team, remainingDays: 3)
            } else {
//                trackUserEvent(.OPEN, value: self.team?.remoteID, valueType: .TEAM_TO_BE_VISION_RATING, action: .TAP)
                self.router.showRatingExplanation(team: self.team)
            }
        }

    }

    func shareTeamToBeVision() {
        guard let vision = teamVision else { return }
        worker.getTeamToBeVisionShareData(vision) { [weak self] (visionShare, error) in
            guard error == nil else {
                log("Getting Share Content Failed- \(error!)", level: .error)
                self?.router.showAlert(type: .message(error!.localizedDescription),
                                       handler: nil, handlerDestructive: nil)
                return
            }
            let activityVC = UIActivityViewController(activityItems: [visionShare?.plainBody ?? ""],
                                                      applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.openInIBooks,
                                                UIActivity.ActivityType.airDrop,
                                                UIActivity.ActivityType.postToTencentWeibo,
                                                UIActivity.ActivityType.postToVimeo,
                                                UIActivity.ActivityType.postToFlickr,
                                                UIActivity.ActivityType.addToReadingList,
                                                UIActivity.ActivityType.saveToCameraRoll,
                                                UIActivity.ActivityType.assignToContact,
                                                UIActivity.ActivityType.postToFacebook,
                                                UIActivity.ActivityType.postToTwitter]

            activityVC.completionWithItemsHandler = { (_, _, _, _) in
                // swizzle back to original
                swizzleMFMailComposeViewControllerMessageBody()
            }

            self?.router.showViewController(viewController: activityVC) {
                // after present swizzle for mail
                swizzleMFMailComposeViewControllerMessageBody()
            }
        }
    }

    private func dateString(for day: Int) -> String {
        if day == 0 {
            return "Today"
        } else if day == 1 {
            return "Yesterday"
        } else {
            return String(day) + " Days"
        }
    }
}
