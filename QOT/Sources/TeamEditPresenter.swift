//
//  TeamEditPresenter.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamEditPresenter {

    // MARK: - Properties
    private weak var viewController: TeamEditViewControllerInterface?

    // MARK: - Init
    init(viewController: TeamEditViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - Private
private extension TeamEditPresenter {
    func updateLabels(_ type: TeamEdit.View, teamName: String? = nil, animated: Bool) {
        var subHeader = TeamEdit.subHeader.label(type: type)
        if type == .memberInvite {
            subHeader = String(format: subHeader, teamName ?? "")
        }
        viewController?.setupLabels(header: TeamEdit.header.label(type: type),
                                    subHeader: subHeader,
                                    description: TeamEdit.description.label(type: type),
                                    cta: TeamEdit.cta.label(type: type),
                                    animated: animated)
    }
}

// MARK: - TeamEditInterface
extension TeamEditPresenter: TeamEditPresenterInterface {
    func refreshMemberList(at indexPath: [IndexPath]) {
        viewController?.refreshMemberList(at: indexPath)
    }

    func prepareMemberInvite(_ teamName: String?, maxMemberCount: Int) {
        updateLabels(.memberInvite, teamName: teamName, animated: true)
        viewController?.updateTextCounter(type: .memberInvite, max: maxMemberCount, teamName: nil)
        viewController?.refreshView(.memberInvite)
    }

    func setupView(_ type: TeamEdit.View, teamName: String?) {
        viewController?.setupView(type, teamName)
        updateLabels(type, animated: false)
    }

    func setupTextCounter(type: TeamEdit.View, max: Int, teamName: String?) {
        viewController?.updateTextCounter(type: type, max: max, teamName: teamName)
    }

    func presentErrorAlert(_ title: String, _ message: String) {
        viewController?.presentErrorAlert(title, message)
    }
}
