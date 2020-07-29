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
    func updateLabels(_ type: TeamEdit.View, animated: Bool) {
        viewController?.setupLabels(header: TeamEdit.header.label(type: type),
                                    subHeader: TeamEdit.subHeader.label(type: type),
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

    func prepareMemberInvite(_ team: QDMTeam?) {
        updateLabels(.memberInvite, animated: true)
        viewController?.updateTextCounter(maxChars: nil)
        viewController?.refreshView()
    }

    func setupView(_ type: TeamEdit.View) {
        viewController?.setupView()
        updateLabels(type, animated: false)
    }

    func setupTextCounter(maxChars: Int) {
        viewController?.updateTextCounter(maxChars: maxChars)
    }

    func presentErrorAlert(_ title: String, _ message: String) {
        viewController?.presentErrorAlert(title, message)
    }
}
