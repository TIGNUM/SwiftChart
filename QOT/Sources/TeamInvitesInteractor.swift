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
    private var qdmInvitations = [QDMTeamInvitation]()
    private var pendingInvites = [TeamInvite.Pending]()
    private var partOfTeams = 0
    private var maxTeamCount = 0
    private var canJoinTeam = true

    // MARK: - Init
    init(presenter: TeamInvitesPresenterInterface, invitations: [QDMTeamInvitation]) {
        self.presenter = presenter
        self.qdmInvitations = invitations
    }

    // MARK: - Interactor
    func viewDidLoad() {
        addObservers()
        presenter.setupView()
        worker.getInviteHeader { [weak self] (header) in
            self?.setTeamAttributes {
                self?.maxTeamCount = header.maxTeams
                self?.inviteHeader = header
                self?.setPendingInvites()
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
            worker.joinTeamInvite(teamInvite) { [weak self] (teams) in
                self?.setTeamAttributes {
                    //TODO update view
                }
            }
        }
    }

    @objc func didSelectDeclineTeamInvite(_ notification: Notification) {
        if let teamInvite = notification.object as? QDMTeamInvitation {
            worker.declineTeamInvite(teamInvite) { [weak self] (teams) in
                self?.setTeamAttributes {
                    //TODO update view
                }
            }
        }
    }

    func setTeamAttributes(_ completion: @escaping () -> Void) {
        worker.getTeams { [weak self] (teams) in
            self?.worker.canJoinTeam { (canJoinTeam) in
                self?.canJoinTeam = canJoinTeam
                self?.partOfTeams = teams.count
                completion()
            }
        }
    }

    func setPendingInvites() {
        pendingInvites = qdmInvitations.compactMap { (invite) -> TeamInvite.Pending in
            return TeamInvite.Pending(invite: invite, canJoin: canJoinTeam, maxTeamCount: maxTeamCount)
        }
    }
}

// MARK: - TeamInvitesInteractorInterface
extension TeamInvitesInteractor: TeamInvitesInteractorInterface {
    var sectionCount: Int {
        return TeamInvite.Section.allCases.count
    }

    func rowCount(in section: Int) -> Int {
        switch TeamInvite.Section.allCases[section] {
        case .header: return 1
        case .pendingInvite: return pendingInvites.count
        }
    }

    func section(at indexPath: IndexPath) -> TeamInvite.Section {
        return TeamInvite.Section.allCases[indexPath.section]
    }

    func pendingInvites(at indexPath: IndexPath) -> TeamInvite.Pending? {
        return pendingInvites.at(index: indexPath.row)
    }

    func headerItem() -> (header: TeamInvite.Header?, teamCount: Int) {
        return (header: inviteHeader, teamCount: partOfTeams)
    }
}
