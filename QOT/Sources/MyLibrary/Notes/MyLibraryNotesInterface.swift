//
//  MyLibraryNotesInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyLibraryNotesViewControllerInterface: class {
    func update()
    func beginEditing()
    func showAlert(title: String?, message: String?, buttons: [UIBarButtonItem])
}

protocol MyLibraryNotesPresenterInterface {
    func present()
    func continueEditing()
    func presentAlert(title: String?, message: String?, buttons: [UIBarButtonItem])
}

protocol MyLibraryNotesInteractorInterface: Interactor {
    var placeholderText: String { get }
    var saveTitle: String { get }
    var noteText: String? { get }
    var isSaveButtonEnabled: Bool { get }
    var showDeleteButton: Bool { get }
    var isCreatingNewNote: Bool { get }

    func didUpdateText(_ text: String?)
    func saveNoteText(_ text: String?)
    func didTapDismiss(with text: String?)
    func didTapDelete()
}

protocol MyLibraryNotesRouterInterface {
    func dismiss()
}
