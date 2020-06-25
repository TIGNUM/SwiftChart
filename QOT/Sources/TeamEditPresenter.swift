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
//    func handleResponseMemberInvite(_ member: QDMTeamMember?, error: Error?) {
//        if let error = error {
//            log("Error while member invite: \(error.localizedDescription)", level: .error)
//            viewController?.showErrorAlert(error)
//        } else if member == nil {
//            log("Member could not be invited. Did not get a valid member as response.", level: .error)
//            let error = NSError(domain: TeamServiceErrorDomain,
//                                code: TeamServiceErrorCode.CannotFindTeamMember.rawValue,
//                                userInfo: nil)
//            viewController?.showErrorAlert(error)
//        } else {
            // TODO, empty textField, move email to list, update counter
//            UIView.animate(withDuration: Animation.duration_04) { [weak self] in
//                self?.setupView(.memberInvite)
//            }
//        }
//    }

    func refreshMemberList() {
        viewController?.refreshMemberList()
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

    func presentErrorAlert(_ error: Error?) {
        var title = "Error"
        var message = "Message"
        if let error = error {
            title = "Error"
            message = "Message"
        } else {
            title = "Error"
            message = "Message"
        }
        viewController?.presentErrorAlert(title, message)
    }
}
