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
    private var inviteItems: [TeamInvite.Invitation] = []

    // MARK: - Init
    init(presenter: TeamInvitesPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        addObservers()
        presenter.setupView()
        worker.getInviteHeader { (header) in
            self.worker.getInviteItems { (items) in
                self.inviteHeader = header
                self.inviteItems = items
                self.presenter.reload()
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
                // TODO update view
            }
        }
    }

    @objc func didSelectDeclineTeamInvite(_ notification: Notification) {
        if let teamInvite = notification.object as? QDMTeamInvitation {
            worker.declineTeamInvite(teamInvite) { (teams) in
                // TODO update view
            }
        }
    }
}

// MARK: - TeamInvitesInteractorInterface
extension TeamInvitesInteractor: TeamInvitesInteractorInterface {

    var sectionCount: Int {
        return inviteItems.isEmpty ? 0 : 2
    }

    func rowCount(in section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return inviteItems.count
        default: return 0
        }
    }

    func inviteItem(at row: Int) -> TeamInvite.Invitation {
        return inviteItems[row]
    }

    func headerItem() -> TeamInvite.Header? {
        return inviteHeader
    }
}
