//
//  TeamInvitesInteractor.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamInvitesInteractor: TeamInvitesWorker {

    // MARK: - Properties
    private let presenter: TeamInvitesPresenterInterface!
    private var inviteHeader: TeamInvite.Header?
    private var teamItems = [Team.Item]()
    private var qdmInvitations = [QDMTeamInvitation]()
    private var pendingInvites = [TeamInvite.Pending]()
    private var partOfTeams = 0
    private var maxTeamCount = 0
    private var canJoinTeam = true

    // MARK: - Init
    init(presenter: TeamInvitesPresenterInterface, teamItems: [Team.Item]) {
        self.presenter = presenter
        self.teamItems = teamItems
        if let invites = teamItems.filter({ $0.invites.isEmpty == false }).first?.invites {
            qdmInvitations = invites
        }
    }

    // MARK: - Interactor
    func viewDidLoad() {
        addObservers()
        presenter.setupView()
        presenter.reload(shouldDismiss: qdmInvitations.isEmpty)
        let teams = teamItems.filter { $0.header == .team }
        partOfTeams = teams.count
        getMaxTeamCount { (max) in
            self.maxTeamCount = max
            self.setTeamAttributes { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.makePendingInvites(qdmInvitations: strongSelf.qdmInvitations)
                strongSelf.presenter.reload(shouldDismiss: strongSelf.pendingInvites.isEmpty)
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
            joinTeamInvite(teamInvite) { [weak self] (teams) in
                self?.setTeamAttributes {
                    self?.updateItemsAndReload()
                }
            }
        }
    }

    @objc func didSelectDeclineTeamInvite(_ notification: Notification) {
        if let teamInvite = notification.object as? QDMTeamInvitation {
            declineTeamInvite(teamInvite) { [weak self] (teams) in
                self?.setTeamAttributes {
                    self?.updateItemsAndReload()
                }
            }
        }
    }

    func updateItemsAndReload() {
        getTeamInvitations { [weak self] (qdmInvitations) in
            self?.makePendingInvites(qdmInvitations: qdmInvitations)
            self?.presenter.reload(shouldDismiss: self?.pendingInvites.isEmpty == true)
        }
    }

    func makePendingInvites(qdmInvitations: [QDMTeamInvitation]) {
        pendingInvites = qdmInvitations
            .filter { $0.me?.status == .INVITED }
            .compactMap { (invite) -> TeamInvite.Pending in
            return TeamInvite.Pending(invite: invite,
                                      canJoin: canJoinTeam,
                                      maxTeamCount: maxTeamCount)
        }
    }

    func setTeamAttributes(_ completion: @escaping () -> Void) {
        let maxTeams = maxTeamCount
        getTeams { [weak self] (teams) in
            self?.canJoinTeam = teams.count < maxTeams
            self?.partOfTeams = teams.count
            self?.inviteHeader = TeamInvite.Header(maxTeams: maxTeams, partOfTeams: teams.count)
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
