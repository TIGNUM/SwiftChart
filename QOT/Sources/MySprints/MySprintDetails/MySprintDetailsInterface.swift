//
//  MySprintDetailsInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MySprintDetailsViewControllerInterface: class {
    func setupView()
    func update()
    func trackSprintPause()
    func trackSprintContinue()
    func trackSprintStart()
    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem])
}

protocol MySprintDetailsPresenterInterface {
    func setupView()
    func present()
    func trackSprintPause()
    func trackSprintContinue()
    func trackSprintStart()
    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem])
}

protocol MySprintDetailsInteractorInterface: Interactor {
    var viewModel: MySprintDetailsViewModel { get }
    func updateViewModel()

    func didDismissAlert()
    func didTapItemAction(_ rawValue: Int)
}

protocol MySprintDetailsRouterInterface {
    func presentTakeawayCapture(for sprint: QDMSprint)
    func presentNoteEditing(for sprint: QDMSprint, action: MySprintDetailsItem.Action)
}
