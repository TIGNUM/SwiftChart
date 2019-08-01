//
//  MySprintNotesInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MySprintNotesViewControllerInterface: class {
    func update()
    func beginEditing()
}

protocol MySprintNotesPresenterInterface {
    func present()
    func continueEditing()
}

protocol MySprintNotesInteractorInterface: Interactor {
    var infoViewModel: MySprintsInfoAlertViewModel? { get }
    var title: String { get }
    var characterCountText: String { get }
    var saveTitle: String { get }
    var noteText: String? { get }
    var bottomButtons: [ButtonParameters]? { get }

    func didUpdateText(_ text: String?)
    func saveNoteText(_ text: String?)
    func didTapDismiss(with text: String?)
    func shouldChangeText(_ text: String, shouldChangeTextIn range: NSRange, replacementText: String) -> Bool
}

protocol MySprintNotesRouterInterface {
    func dismiss()
}
