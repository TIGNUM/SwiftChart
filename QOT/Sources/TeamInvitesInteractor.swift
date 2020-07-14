//
//  TeamInvitesInteractor.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

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
