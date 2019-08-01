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

    private (set) var infoViewModel: MyLibraryUserStorageInfoViewModel? = nil
    private (set) var bottomButtons: [ButtonParameters]? = nil
    // Text received from the viewController
    private var text: String?

    private lazy var dismissButtons: [ButtonParameters] = {
        return [ButtonParameters(title: worker.leaveButtonTitle, target: self, action: #selector(continueDismissingTapped)),
                ButtonParameters(title: worker.cancelTitle, target: self, action: #selector(cancelDismissingTapped))]
    }()

    private lazy var removeButtons: [ButtonParameters] = {
        return [ButtonParameters(title: worker.removeButtonTitle, target: self, action: #selector(continueRemovingTapped)),
                ButtonParameters(title: worker.cancelTitle, target: self, action: #selector(cancelRemovingTapped))]
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
        // Show info view
        infoViewModel = MyLibraryUserStorageInfoViewModel(isFullscreen: true,
                                                          icon: R.image.my_library_warning() ?? UIImage(),
                                                          title: worker.dismissAlertTitle,
                                                          message: worker.dismissAlertMessage,
                                                          userParameter: nil)
        bottomButtons = dismissButtons
        presenter.present()
    }

    func didTapDelete() {
        infoViewModel = MyLibraryUserStorageInfoViewModel(isFullscreen: true,
                                                          icon: R.image.my_library_warning() ?? UIImage(),
                                                          title: worker.removeAlertTitle,
                                                          message: worker.removeAlertMessage,
                                                          userParameter: nil)
        bottomButtons = removeButtons
        presenter.present()
    }
}

// MARK: - Private methods
extension MyLibraryNotesInteractor {
    @objc private func cancelDismissingTapped() {
        infoViewModel = nil
        bottomButtons = nil
        presenter.present()
        presenter.continueEditing()
    }

    @objc private func continueDismissingTapped() {
        router.dismiss()
    }

    @objc private func cancelRemovingTapped() {
        infoViewModel = nil
        bottomButtons = nil
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
