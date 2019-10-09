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
import qot_dal

final class DTPrepareViewController: DTViewController {

    // MARK: - Properties
    weak var resultsDelegate: PrepareResultsDelegatge?
    var prepareInteractor: DTPrepareInteractor?
    var prepareRouter: DTPrepareRouterInterface?
    private var selectedEvent: DTViewModel.Event?
    private var answerFilter: String?

    // MARK: - Init
    init(configure: Configurator<DTPrepareViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Answer Handling
    override func didTapClose() {
        if resultsDelegate != nil {
            prepareRouter?.dismissResultView()
            trackQuestionInteraction()
        } else {
            super.didTapClose()
        }
    }

    override func didTapNext() {
        if resultsDelegate != nil {
            if viewModel?.question.key == Prepare.QuestionKey.BenefitsInput {
                resultsDelegate?.didUpdateBenefits(prepareInteractor?.inputText ?? "")
                prepareRouter?.dismissResultView()
            } else {
                let answerIds = viewModel?.selectedAnswers.compactMap { $0.remoteId } ?? []
                resultsDelegate?.didUpdateIntentions(answerIds)
                prepareRouter?.dismissResultView()
            }
            return
        }

        //multi-select and OK buttons call the same 'setAnswerNeedsSelection' method, this always selects answer[0]
        setAnswerNeedsSelectionIfNoOtherAnswersAreSelectedAlready()
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
        setSelectedAnswer(answer)
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
        super.didSelectPreparationEvent(event)
        if event?.isCalendarEvent == false && viewModel?.question.key == Prepare.QuestionKey.SelectExisting {
            prepareInteractor?.getUserPreparation(event: event,
                                                  calendarEvent: selectedEvent) { [weak self] (preparation) in
                                                    self?.prepareRouter?.presentPrepareResults(preparation)
            }
        } else {
            self.selectedEvent = event
            setAnswerNeedsSelection()
            loadNextQuestion()
        }
    }

    override func getEvent(answerType: AnswerType?) -> DTViewModel.Event? {
        return answerType == .openCalendarEvents ? selectedEvent : nil
    }

    override func getAnswerFilter(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        if questionKey == Prepare.QuestionKey.EventTypeSelectionCritical {
            answerFilter = selectedAnswers.flatMap { $0.keys }.filter { $0.contains(Prepare.AnswerFilter) }.first
        }
        switch questionKey {
        case Prepare.QuestionKey.ShowTBV?,
             Prepare.Key.know.rawValue?,
             Prepare.Key.perceived.rawValue?:
            return answerFilter
        default:
            return nil
        }
    }
}

// MARK: - Private
private extension DTPrepareViewController {
    func handleAnswerSelection(_ answer: DTViewModel.Answer, contentId: Int) {
        if answer.keys.contains(Prepare.AnswerKey.OpenCheckList) {
            prepareRouter?.presentPrepareResults(contentId)
        } else if answer.keys.contains(Prepare.AnswerKey.KindOfEventSelectionDaily) {
            prepareInteractor?.getUserPreparation(answer: answer, event: selectedEvent) { [weak self] (preparation) in
                self?.prepareRouter?.presentPrepareResults(preparation)
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
                                                            let targetId = Prepare.QuestionTargetId.IntentionPerceived
                                                            let targetAnswer = DTViewModel.Answer(answer: answer,
                                                                                                  newTargetId: targetId)
                                                            self?.setAnswerNeedsSelection(targetAnswer)
                                                            self?.loadNextQuestion()
                }
            }
        }
    }

    func createPreparationAndPresent() {
        prepareInteractor?.getUserPreparation(event: selectedEvent) { [weak self] (preparation) in
            self?.prepareRouter?.presentPrepareResults(preparation)
        }
    }

    func resetSelectedAnswers() {
        if var viewModel = viewModel {
            viewModel.resetSelectedAnswers()
            showQuestion(viewModel: viewModel, direction: .forward, animated: false)
        }
    }
}

extension DTPrepareViewController: AskPermissionDelegate {
    func didFinishAskingForPermission(type: AskPermission.Kind, granted: Bool) {
        if granted {
            presentCalendarSettings()
        } else {
            resetSelectedAnswers()
        }
    }
}

// MARK: - DTPrepareViewControllerInterface
extension DTPrepareViewController: DTPrepareViewControllerInterface {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
        prepareRouter?.presentCalendarPermission(permissionType)
    }

    func presentCalendarSettings() {
        self.prepareRouter?.presentCalendarSettings()
    }
}

// MARK: - SyncedCalendarsDelegate
extension DTPrepareViewController: SyncedCalendarsDelegate {
    func didFinishSyncingCalendars(qdmEvents: [QDMUserCalendarEvent]) {
        if qdmEvents.isEmpty {
            resetSelectedAnswers()
        } else {
            prepareInteractor?.setUserCalendarEvents(qdmEvents)
            loadNextQuestion()
        }
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
