//
//  MySprintNotesInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintNotesInteractor {

    // MARK: - Properties

    private let worker: MySprintNotesWorker
    private let presenter: MySprintNotesPresenterInterface
    private let router: MySprintNotesRouterInterface
    private let notificationCenter: NotificationCenter

    private (set) var infoViewModel: MySprintsInfoAlertViewModel? = nil
    private (set) var bottomButtons: [ButtonParameters]? = nil
    // Text received from the viewController
    private var text: String?
    private let maxCharacterCount = 250

    private lazy var dismissButtons: [ButtonParameters] = {
        return [ButtonParameters(title: worker.leaveButtonTitle, target: self, action: #selector(continueDismissingTapped)),
                ButtonParameters(title: worker.cancelTitle, target: self, action: #selector(cancelDismissingTapped))]
    }()

    // MARK: - Init

    init(worker: MySprintNotesWorker,
        presenter: MySprintNotesPresenterInterface,
        router: MySprintNotesRouterInterface,
        notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.notificationCenter = notificationCenter
    }

    // MARK: - Interactor

    func viewDidLoad() {
        text = worker.text
        presenter.present()
    }
}

// MARK: - MySprintNotesInteractorInterface

extension MySprintNotesInteractor: MySprintNotesInteractorInterface {

    var title: String {
        return worker.title
    }

    var characterCountText: String {
        return "\(text?.count ?? 0)/\(maxCharacterCount)"
    }

    var saveTitle: String {
        return worker.saveTitle
    }

    var noteText: String? {
        return text ?? worker.text
    }

    func didUpdateText(_ text: String?) {
        self.text = text
    }

    func saveNoteText(_ text: String?) {
        worker.saveText(text) { [weak self] (sprint, error) in
            if error != nil {
                qot_dal.log("Failed to pdate sprint note. Error: \(String(describing: error))", level: .error)
            } else if let sprint = sprint {
                self?.notificationCenter.post(name: .didUpdateMySprintsData,
                                              object: nil,
                                              userInfo: [Notification.Name.MySprintDetailsKeys.sprint: sprint])
            }
            self?.router.dismiss()
        }
    }

    func didTapDismiss(with text: String?) {
        self.text = text
        if text == (worker.text ?? "") {
            router.dismiss()
            return
        }
        // Show info view
        infoViewModel = MySprintsInfoAlertViewModel(isFullscreen: true,
                                                    style: .regular,
                                                    icon: R.image.my_library_warning() ?? UIImage(),
                                                    title: worker.dismissAlertTitle,
                                                    message: worker.dismissAlertMessage,
                                                    transparent: false)
        bottomButtons = dismissButtons
        presenter.present()
    }

    func shouldChangeText(_ text: String, shouldChangeTextIn range: NSRange, replacementText: String) -> Bool {
        return text.count + (replacementText.count - range.length) <= maxCharacterCount
    }
}

// MARK: - Private methods
extension MySprintNotesInteractor {
    @objc private func cancelDismissingTapped() {
        infoViewModel = nil
        bottomButtons = nil
        presenter.present()
        presenter.continueEditing()
    }

    @objc private func continueDismissingTapped() {
        router.dismiss()
    }
}
