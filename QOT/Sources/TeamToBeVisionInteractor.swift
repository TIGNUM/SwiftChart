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

    // MARK: - Init
    init(presenter: TeamToBeVisionPresenterInterface, router: TeamToBeVisionRouter, team: QDMTeam?) {
        self.presenter = presenter
        self.router = router
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }

    func viewWillAppear() {
        didUpdateTBVRelatedData()
    }

    private func didUpdateTBVRelatedData() {
        guard let team = team else { return }
        worker.getTeamToBeVision(for: team) { [weak self] (teamVision) in
//            self?.worker.getRateButtonValues { [weak self] (text, shouldShowSingleMessage, status) in
                self?.presenter.load(teamVision,
                                     rateText: "",
                                     isRateEnabled: false,
                                     shouldShowSingleMessageRating: true)
            }
//        }
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

    func showNullState(with title: String, message: String, writeMessage: String) {
        presenter.showNullState(with: title, message: message, writeMessage: writeMessage)
    }

    func hideNullState() {
        presenter.hideNullState()
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
        guard let team = team else { return nil }
        worker.getTeamToBeVision(for: team) { (teamVision) in
            guard let date = teamVision?.date?.beginingOfDate() else { return }
            let days = DateComponentsFormatter.numberOfDays(date)
            lastUpdatedVision = self.dateString(for: days)
        }
        return lastUpdatedVision
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
