//
//  MyLibraryNotesInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryNotesInteractor {

    // MARK: - Properties

    private let worker: MyLibraryNotesWorker
    private let presenter: MyLibraryNotesPresenterInterface
    private let router: MyLibraryNotesRouterInterface
    private let notificationCenter: NotificationCenter

    // Text received from the viewController
    private var text: String?

    private lazy var dismissButtons: [UIBarButtonItem] = {
        return [RoundedButton.barButton(title: worker.cancelTitle, target: self, action: #selector(cancelDismissingTapped)),
                RoundedButton.barButton(title: worker.leaveButtonTitle, target: self, action: #selector(continueDismissingTapped))]
    }()

    private lazy var removeButtons: [UIBarButtonItem] = {
        return [RoundedButton.barButton(title: worker.cancelTitle, target: self, action: #selector(cancelRemovingTapped)),
                RoundedButton.barButton(title: worker.removeButtonTitle, target: self, action: #selector(continueRemovingTapped))]
    }()

    // MARK: - Init

    init(worker: MyLibraryNotesWorker,
        presenter: MyLibraryNotesPresenterInterface,
        router: MyLibraryNotesRouterInterface,
        notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.notificationCenter = notificationCenter
    }

    // MARK: - Interactor

    func viewDidLoad() {
        worker.getText { [weak self] (text) in
            self?.presenter.present()
        }
    }
}

// MARK: - MyLibraryNotesInteractorInterface

extension MyLibraryNotesInteractor: MyLibraryNotesInteractorInterface {

    var placeholderText: String {
        return worker.placeholderText
    }

    var saveTitle: String {
        return worker.saveTitle
    }

    var noteText: String? {
        return text ?? worker.text
    }

    var isSaveButtonEnabled: Bool {
        return !(text?.isEmpty ?? true)
    }

    func didUpdateText(_ text: String?) {
        self.text = text
    }

    var showDeleteButton: Bool {
        return worker.isExistingNote
    }

    var isCreatingNewNote: Bool {
        return !worker.isExistingNote
    }

    func saveNoteText(_ text: String?) {
        worker.saveText(text) { [weak self] (_, error) in
            if error != nil {
                qot_dal.log("Failed to save note. Error: \(String(describing: error))", level: .error)
            } else {
                self?.notificationCenter.post(name: .didUpdateMyLibraryData, object: nil)
                self?.router.dismiss()
            }
        }
    }

    func didTapDismiss(with text: String?) {
        self.text = text
        if text == (worker.text ?? "") || text == placeholderText {
            router.dismiss()
            return
        }
        presenter.presentAlert(title: worker.dismissAlertTitle, message: worker.dismissAlertMessage, buttons: dismissButtons)
    }

    func didTapDelete() {
        presenter.presentAlert(title: worker.removeAlertTitle, message: worker.removeAlertMessage, buttons: removeButtons)
    }
}

// MARK: - Private methods
extension MyLibraryNotesInteractor {
    @objc private func cancelDismissingTapped() {
        presenter.present()
        presenter.continueEditing()
    }

    @objc private func continueDismissingTapped() {
        router.dismiss()
    }

    @objc private func cancelRemovingTapped() {
        presenter.present()
    }

    @objc private func continueRemovingTapped() {
        worker.deleteNote { [weak self] (error) in
            guard error == nil else {
                qot_dal.log("Failed to delete the note. Error: \(String(describing: error))")
                return
            }
            self?.notificationCenter.post(name: .didUpdateMyLibraryData, object: nil)
            self?.router.dismiss()
        }
    }
}
