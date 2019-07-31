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
    func update()
}

protocol MySprintDetailsPresenterInterface {
    func present()
}

protocol MySprintDetailsInteractorInterface: Interactor {
    var viewModel: MySprintDetailsViewModel { get }

    func didDismissAlert()
    func didTapItemAction(_ rawValue: Int)
}

protocol MySprintDetailsRouterInterface {
    func presentTakeawayCapture(for sprint: QDMSprint)
}
