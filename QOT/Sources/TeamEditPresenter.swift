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
    func updateView(_ type: TeamEdit.View, animated: Bool) {
        viewController?.setupLabels(header: TeamEdit.header.label(type: type),
                                    subHeader: TeamEdit.subHeader.label(type: type),
                                    description: TeamEdit.description.label(type: type),
                                    cta: TeamEdit.cta.label(type: type),
                                    animated: animated)
    }
}

// MARK: - TeamEditInterface
extension TeamEditPresenter: TeamEditPresenterInterface {
    func handleResponseCreate(_ team: QDMTeam?, error: Error?) {
        if let error = error {
            log("Error while create team: \(error.localizedDescription)", level: .error)
            viewController?.showErrorAlert(error)
        } else if team == nil {
            log("Team could not be created. Did not get a valid team as response.", level: .error)
            let error = NSError(domain: TeamServiceErrorDomain,
                                code: TeamServiceErrorCode.CannotFindTeam.rawValue,
                                userInfo: nil)
            viewController?.showErrorAlert(error)
        } else {
            updateView(.memberInvite, animated: true)
            viewController?.hideCounterLabels(true)
            viewController?.refreshView()
        }
    }

    func handleResponseMemberInvite(_ member: QDMTeamMember?, error: Error?) {
        if let error = error {
            log("Error while member invite: \(error.localizedDescription)", level: .error)
            viewController?.showErrorAlert(error)
        } else if member == nil {
            log("Member could not be invited. Did not get a valid member as response.", level: .error)
            let error = NSError(domain: TeamServiceErrorDomain,
                                code: TeamServiceErrorCode.CannotFindTeamMember.rawValue,
                                userInfo: nil)
            viewController?.showErrorAlert(error)
        } else {
            // TODO, empty textField, move email to list, update counter
//            UIView.animate(withDuration: Animation.duration_04) { [weak self] in
//                self?.setupView(.memberInvite)
//            }
        }
    }

    func setupView(_ type: TeamEdit.View) {
        viewController?.setupView()
        updateView(type, animated: false)
    }

    func setupTextCounter(maxChars: Int) {
        viewController?.setupTextCounter(maxChars: maxChars)
    }
}
