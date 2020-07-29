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

        let teams = teamItems.filter { $0.invites.isEmpty }
        partOfTeams = teams.count
        updateHeader { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.canJoinTeam = teams.count < strongSelf.maxTeamCount
            strongSelf.makePendingInvites(qdmInvitations: strongSelf.qdmInvitations)
            strongSelf.presenter.reload(shouldDismiss: strongSelf.pendingInvites.isEmpty)
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
                self?.updateHeader { [weak self] in
                    self?.setTeamAttributes {
                        self?.updateItemsAndReload()
                    }
                }
            }
        }
    }

    @objc func didSelectDeclineTeamInvite(_ notification: Notification) {
        if let teamInvite = notification.object as? QDMTeamInvitation {
            worker.declineTeamInvite(teamInvite) { [weak self] (teams) in
                self?.updateHeader { [weak self] in
                    self?.setTeamAttributes {
                        self?.updateItemsAndReload()
                    }
                }
            }
        }
    }

    func updateItemsAndReload() {
        worker.getTeamInvitations { [weak self] (qdmInvitations) in
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

    func updateHeader(_ completion: @escaping () -> Void) {
        worker.getInviteHeader { [weak self] (header) in
            self?.maxTeamCount = header.maxTeams
            self?.inviteHeader = header
            completion()
        }
    }

    func setTeamAttributes(_ completion: @escaping () -> Void) {
        worker.getTeams { [weak self] (teams) in
            self?.canJoinTeam = teams.count < self?.maxTeamCount ?? 3
            self?.partOfTeams = teams.count
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
