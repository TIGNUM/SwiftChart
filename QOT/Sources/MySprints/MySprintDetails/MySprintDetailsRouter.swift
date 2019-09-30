//
//  MySprintDetailsRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintDetailsRouter {

    // MARK: - Properties

    private weak var viewController: MySprintDetailsViewController?

    // MARK: - Init

    init(viewController: MySprintDetailsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MySprintDetailsRouterInterface

extension MySprintDetailsRouter: MySprintDetailsRouterInterface {
    func presentTakeawayCapture(for sprint: QDMSprint) {
        let configurator = DTSprintReflectionConfigurator.make(sprint: sprint)
        let controller = DTSprintReflectionViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentNoteEditing(for sprint: QDMSprint, action: MySprintDetailsItem.Action) {
        guard let noteController = R.storyboard.mySprintNotes.mySprintNotesViewController() else {
            return
        }
        let configurator = MySprintNotesConfigurator.make()
        configurator(noteController, sprint, action)
        viewController?.present(noteController, animated: true, completion: nil)
    }
}
