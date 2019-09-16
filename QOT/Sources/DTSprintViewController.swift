//
//  DTSprintViewController.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintViewController: DTViewController {

    // MARK: - Properties
    var sprintInteractor: DTSprintInteractorInterface?

    // MARK: - Init
    init(configure: Configurator<DTSprintViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction override func didTapNext() {
        if viewModel?.question.key == Sprint.QuestionKey.Last {
            didTapClose()
        } else {
            setAnswerNeedsSelection()
            loadNextQuestion()
        }
    }

    // MARK: - DTViewControllerInterface
    override func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        trackUserEvent(.OPEN,
                       stringValue: sprintInteractor?.getSelectedSprintTitle(),
                       valueType: .CONTENT,
                       action: .PRESS)
        let cancelButtonItem = roundedBarButtonItem(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel),
                                                    buttonWidth: .Cancel,
                                                    action: #selector(didPressDimissInfoView),
                                                    backgroundColor: .carbonDark,
                                                    borderColor: .accent40)
        let continueButtonItem = roundedBarButtonItem(title: R.string.localized.alertButtonTitleContinue(),
                                                      buttonWidth: .Continue,
                                                      action: #selector(didTapStartSprint),
                                                      backgroundColor: .carbonDark,
                                                      borderColor: .accent40)
        QOTAlert.show(title: title, message: text, bottomItems: [cancelButtonItem, continueButtonItem])
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    override func didTapBinarySelection(_ answer: DTViewModel.Answer) {
        let selectionModel = DTSelectionModel(selectedAnswers: [answer], question: viewModel?.question)
        switch answer.keys.first {
        case Sprint.AnswerKey.StartTomorrow:
            sprintInteractor?.startSprintTomorrow(selection: selectionModel)
        case Sprint.AnswerKey.AddToQueue:
            sprintInteractor?.addSprintToQueue(selection: selectionModel)
        default:
            return
        }
    }
}

// MARK: - Actions
private extension DTSprintViewController {
    @objc func didTapStartSprint() {
        sprintInteractor?.stopActiveSprintAndStartNewSprint()
    }

    @objc func didPressDimissInfoView() {
        trackUserEvent(.CLOSE,
                       stringValue: sprintInteractor?.getSelectedSprintTitle(),
                       valueType: .CONTENT,
                       action: .PRESS)
    }
}

// MARK: - DTSprintPresenterInterface
extension DTSprintViewController: DTSprintViewControllerInterface {
    func presentPermissionView(_ permissionType: AskPermission.Kind) {
        guard let router = router as? DTSprintRouter else { return }
        router.openPermissionView(permissionType)
    }
}
