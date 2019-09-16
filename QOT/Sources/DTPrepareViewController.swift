//
//  DTPrepareViewController.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

final class DTPrepareViewController: DTViewController {

    // MARK: - Properties
    var prepareInteractor: DTPrepareInteractor?
    var prepareRouter: DTPrepareRouterInterface?
    private var selectedEvent: DTViewModel.Event?

    // MARK: - Init
    init(configure: Configurator<DTPrepareViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Answer Handling
    override func didTapNext() {
        setAnswerNeedsSelection()
        switch viewModel?.question.key {
        case Prepare.QuestionKey.BenefitsInput?:
            createPreparationAndPresent()
        case Prepare.QuestionKey.CalendarEventSelectionCritical?,
             Prepare.QuestionKey.CalendarEventSelectionDaily?:
            prepareRouter?.presentEditEventController()
        default:
            loadNextQuestion()
        }
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        if viewModel?.question.answerType == .singleSelection {
            if let contentId = answer.targetId(.content) {
                handleAnswerSelection(answer, contentId: contentId)
            } else {
                switch viewModel?.question.key {
                case Prepare.QuestionKey.BuildCritical?:
                    handleTBVSelection(answer)
                default:
                    loadNextQuestion()
                }
            }
        }
    }

    override func didSelectPreparationEvent(_ event: DTViewModel.Event?) {
        if event?.isCalendarEvent == false && viewModel?.question.key == Prepare.QuestionKey.SelectExisting {
            prepareInteractor?.getUserPreparation(event: event,
                                                  calendarEvent: selectedEvent) { [weak self] (preparation) in
                                                    self?.prepareRouter?.presentPrepareResults(preparation,
                                                                                               canDelete: true)
            }
        } else {
            self.selectedEvent = event
            setAnswerNeedsSelection()
            loadNextQuestion()
        }
    }

    override func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        super.didDeSelectAnswer(answer)
    }

    override func getEvent(answerType: AnswerType?) -> DTViewModel.Event? {
        return answerType == .openCalendarEvents ? selectedEvent : nil
    }
}

// MARK: - Private
private extension DTPrepareViewController {
    func handleAnswerSelection(_ answer: DTViewModel.Answer, contentId: Int) {
        if answer.keys.contains(Prepare.AnswerKey.OpenCheckList) {
            prepareRouter?.presentPrepareResults(contentId)
        } else if answer.keys.contains(Prepare.AnswerKey.KindOfEventSelectionDaily) {
            prepareInteractor?.getUserPreparation(answer: answer, event: selectedEvent) { [weak self] (preparation) in
                self?.prepareRouter?.presentPrepareResults(preparation, canDelete: true)
            }
        } else {
            loadNextQuestion()
        }
    }

    func handleTBVSelection(_ answer: DTViewModel.Answer) {
        prepareInteractor?.getUsersTBV { [weak self] (tbv, initiated) in
            if initiated && tbv?.text != nil {
                self?.loadNextQuestion()
            } else {
                self?.prepareRouter?.loadShortTBVGenerator(introKey: ShortTBV.QuestionKey.IntroPrepare,
                                                           delegate: self?.prepareInteractor) { [weak self] in
                                                            self?.loadNextQuestion()
                }
            }
        }
    }

    func createPreparationAndPresent() {
        prepareInteractor?.getUserPreparation(event: selectedEvent) { [weak self] (preparation) in
            self?.prepareRouter?.presentPrepareResults(preparation, canDelete: true)
        }
    }
}

extension DTPrepareViewController: AskPermissionDelegate {
    func didFinishAskingForPermission(type: AskPermission.Kind, granted: Bool) {
        if granted {
            loadNextQuestion()
        }
    }
}

// MARK: - DTPrepareViewControllerInterface
extension DTPrepareViewController: DTPrepareViewControllerInterface {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
        prepareRouter?.presentCalendarPermission(permissionType)
    }
}

extension DTPrepareViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .canceled,
             .deleted:
            controller.dismiss(animated: true)
        case .saved:
            DispatchQueue.main.async { [weak self] in
                self?.prepareInteractor?.setCreatedCalendarEvent(controller.event) { [weak self] (success) in
                    controller.dismiss(animated: true) { [weak self] in
                        if success {
                            self?.loadNextQuestion()
                        } else {
                            self?.showAlert(type: .calendarNotSynced)
                        }
                    }
                }
            }
        }
    }
}
