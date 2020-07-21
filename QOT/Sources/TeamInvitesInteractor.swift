//
//  TeamInvitesInteractor.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamInvitesInteractor {

    // MARK: - Properties
    private lazy var worker = TeamInvitesWorker()
    private let presenter: TeamInvitesPresenterInterface!
    private var inviteHeader: TeamInvite.Header?
    private var invitations = [QDMTeamInvitation]()
    private var teamCount = 0

    // MARK: - Init
    init(presenter: TeamInvitesPresenterInterface, invitations: [QDMTeamInvitation]) {
        self.presenter = presenter
        self.invitations = invitations
    }

    // MARK: - Interactor
    func viewDidLoad() {
        addObservers()
        presenter.setupView()
        worker.getInviteHeader { [weak self] (header) in
            self?.setTeamCount {
                self?.inviteHeader = header
                self?.presenter.reload()
            }
        }
    }
}

// MARK: - Private
private extension TeamInvitesInteractor {
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectJoinTeam(_:)),
                                               name: .didSelectTeamInviteJoin,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectDeclineTeamInvite(_:)),
                                               name: .didSelectTeamInviteDecline,
                                               object: nil)
    }

    @objc func didSelectJoinTeam(_ notification: Notification) {
        if let teamInvite = notification.object as? QDMTeamInvitation {
            worker.joinTeamInvite(teamInvite) { (teams) in

            }
        }
    }

    @objc func didSelectDeclineTeamInvite(_ notification: Notification) {
        if let teamInvite = notification.object as? QDMTeamInvitation {
            worker.declineTeamInvite(teamInvite) { (teams) in

            }
        }
    }

    func setTeamCount(_ completion: @escaping () -> Void) {
        worker.getTeams { [weak self] (teams) in
            self?.teamCount = teams.count
            completion()
        }
    }
}

// MARK: - TeamInvitesInteractorInterface
extension TeamInvitesInteractor: TeamInvitesInteractorInterface {
    var sectionCount: Int {
        return TeamInvite.Section.allCases.count
    }

    func rowCount(in section: Int) -> Int {
        switch TeamInvite.Section(rawValue: section) {
        case .header: return 1
        case .invite: return invitations.count
        case .none: return 0
        }
    }

    func inviteItem(at row: Int) -> QDMTeamInvitation {
        return invitations[row]
    }

    func headerItem() -> (header: TeamInvite.Header?, teamCount: Int) {
        return (header: inviteHeader, teamCount: teamCount)
    }
}
