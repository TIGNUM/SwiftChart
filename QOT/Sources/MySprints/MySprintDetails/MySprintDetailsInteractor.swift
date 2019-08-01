//
//  MySprintDetailsInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintDetailsInteractor {

    // MARK: - Properties

    private let worker: MySprintDetailsWorker
    private let presenter: MySprintDetailsPresenterInterface
    private let router: MySprintDetailsRouterInterface
    private let notificationCenter: NotificationCenter

    public private(set) var viewModel = MySprintDetailsViewModel()

    // Holds pending action:
    // When a sprint should be started, continued or restarted we need to check if there is an active sprint and warn
    // the user about it (thus pause the action)
    private var actionToContinueOnActiveSprint: (() -> Void)?

    /// Continues previous action
    private lazy var continuePreviousActionButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonContinue, target: self, action: #selector(continueAction))
    }()

    /// Starts the sprint
    private lazy var startSprintButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonStartSprint,
                                      icon: R.image.my_sprints_play(),
                                      target: self,
                                      action: #selector(didTapStartSprint))
    }()

    /// Shows pause sprint alert
    private lazy var pauseSprintButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonPauseSprint,
                                      icon: R.image.my_sprints_pause(),
                                      target: self,
                                      action: #selector(didTapPauseSprint))
    }()

    /// Pauses the sprint
    private lazy var yesPauseButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonYesPause,
                                      target: self,
                                      action: #selector(pauseSprint))
    }()

    /// Shows continue paused sprint alert
    private lazy var continueSprintButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonContinue,
                                      icon: R.image.my_sprints_play(),
                                      target: self,
                                      action: #selector(didTapContinueSprint))
    }()

    /// Restarts paused sprint
    private lazy var restartPausedButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonRestartSprint,
                                      target: self,
                                      action: #selector(restartPausedSprint))
    }()

    /// Continues paused sprint
    private lazy var continuePausedButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonContinueSprint,
                                      target: self,
                                      action: #selector(continuePausedSprint))
    }()

    /// Cancels the action
    private lazy var cancelButton: SprintButtonParameters = {
        return SprintButtonParameters(title: worker.buttonCancel, target: self, action: #selector(cancelAction))
    }()

    // MARK: - Init

    init(worker: MySprintDetailsWorker,
        presenter: MySprintDetailsPresenterInterface,
        router: MySprintDetailsRouterInterface,
        notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.worker = worker
        self.presenter = presenter
        self.router = router

        self.notificationCenter = notificationCenter
        self.notificationCenter.addObserver(self,
                                            selector: #selector(didUpdateSprintDetails(_:)),
                                            name: .didUpdateMySprintsData,
                                            object: nil)
    }

    // MARK: - Interactor

    func viewDidLoad() {
        viewModel = viewModel(from: worker.sprint)
        presenter.present()
    }
}

// MARK: - MySprintDetailsInteractorInterface

extension MySprintDetailsInteractor: MySprintDetailsInteractorInterface {

    func didDismissAlert() {
        cancelAction()
    }

    func didTapItemAction(_ rawValue: Int) {
        guard let action = MySprintDetailsItem.Action(rawValue: rawValue) else {
            assertionFailure("Unknown action tapped!")
            return
        }
        switch action {
        case .captureTakeaways:
            router.presentTakeawayCapture(for: worker.sprint)
        case .benefits, .highlights, .strategies:
            updateSprintReflection(action)
        }
    }
}

// MARK: - Bottom button actions

extension MySprintDetailsInteractor {

    @objc private func continueAction() {
        actionToContinueOnActiveSprint?()
        actionToContinueOnActiveSprint = nil
    }

    @objc private func didTapStartSprint() {
        checkSprintInProgress { [weak self] in
            self?.startSprint()
        }
    }

    @objc private func startSprint() {
        worker.startSprint { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.presenter.trackSprintStart()
            strongSelf.updateSprintViewModel(with: strongSelf.worker.sprint)
        }
    }

    @objc private func didTapPauseSprint() {
        showPauseSprintAlert()
    }

    @objc private func pauseSprint() {
        worker.pauseSprint { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.presenter.trackSprintPause()
            strongSelf.updateSprintViewModel(with: strongSelf.worker.sprint)
        }
    }

    @objc private func didTapContinueSprint() {
        checkSprintInProgress { [weak self] in
            self?.showContinueSprintAlert()
        }
    }

    @objc private func restartPausedSprint() {
        startSprint()
    }

    @objc private func continuePausedSprint() {
        worker.continueSprint { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.presenter.trackSprintContinue()
            strongSelf.updateSprintViewModel(with: strongSelf.worker.sprint)
        }
    }

    @objc private func cancelAction() {
        viewModel.infoViewModel = nil
        viewModel.showDismissButton = true
        viewModel.rightButtons = bottomButtons(for: worker.sprint)
        presenter.present()
    }
}

// MARK: - View model creation methods

extension MySprintDetailsInteractor {

    private func updateSprintViewModel(with sprint: QDMSprint) {
        viewModel = viewModel(from: sprint)
        presenter.present()
    }

    private func viewModel(from dataModel: QDMSprint) -> MySprintDetailsViewModel {
        let progress = "\(dataModel.currentDay)/\(dataModel.maxDays)"
        let items = listItems(from: dataModel)

        return MySprintDetailsViewModel(title: dataModel.title,
                                        description: dataModel.subtitle,
                                        progress: progress,
                                        items: items,
                                        infoViewModel: nil,
                                        showDismissButton: true,
                                        rightButtons: bottomButtons(for: dataModel))
    }

    private func listItems(from sprint: QDMSprint) -> [MySprintDetailsItem] {
        switch worker.sprintStatus {
        case .upcoming:
            return upcomintSprintItems(from: sprint)
        case .active, .paused:
            return activeSprintItems(from: sprint)
        case .completed:
            return completedSprintItems(from: sprint)
        }
    }

    private func upcomintSprintItems(from sprint: QDMSprint) -> [MySprintDetailsItem] {
        var items = [MySprintDetailsItem]()
        items.append(MySprintDetailsItem(type: .header(action: nil), text: worker.headerSprintTasks))
        items.append(MySprintDetailsItem(type: .listItem(appearance: .info), text: worker.upcomingInfoText))
        return items
    }

    private func activeSprintItems(from sprint: QDMSprint) -> [MySprintDetailsItem] {
        var items = [MySprintDetailsItem]()
        items.append(MySprintDetailsItem(type: .header(action: nil), text: worker.headerSprintTasks))
        let currentDay = sprint.currentDay - 1
        // Sprint is schedule to start
        guard currentDay >= 0 else {
            items.append(MySprintDetailsItem(type: .listItem(appearance: .info), text: worker.activeInfoText))
            return items
        }
        // Sprint is running, show tasks up to day
        for (index, title) in titles(for: sprint.taskItems).enumerated() {
            if index == currentDay {
                items.append(MySprintDetailsItem(type: .listItem(appearance: .active), text: title))
                break
            } else {
                items.append(MySprintDetailsItem(type: .listItem(appearance: .regular), text: title))
            }
        }
        return items
    }

    private func completedSprintItems(from sprint: QDMSprint) -> [MySprintDetailsItem] {
        var items = [MySprintDetailsItem]()
        // Tasks
        items.append(MySprintDetailsItem(type: .header(action: nil), text: worker.headerSprintTasks))
        items.append(contentsOf: titles(for: sprint.taskItems).compactMap {
            MySprintDetailsItem(type: .listItem(appearance: .regular), text: $0)
        })
        // My Plan
        items.append(MySprintDetailsItem(type: .header(action: nil), text: worker.headerMyPlan))
        items.append(contentsOf: titles(for: sprint.planItems).compactMap({
            MySprintDetailsItem(type: .listItem(appearance: .regular), text: $0)
        }))
        // My Notes
        if sprint.notesBenefits == nil || sprint.notesLearnings == nil || sprint.notesReflection == nil {
            items.append(contentsOf: emptyTakeawayItems())
        } else {
            items.append(contentsOf: takeawayItems(from: sprint))
        }

        return items
    }

    private func emptyTakeawayItems() -> [MySprintDetailsItem] {
        var items = [MySprintDetailsItem]()
        items.append(MySprintDetailsItem(type: .header(action: nil), text: worker.headerMyNotes))
        items.append(MySprintDetailsItem(type: .listItem(appearance: .info), text: worker.notesInfoText))
        items.append(MySprintDetailsItem(type: .ctaItem(action: .captureTakeaways), text: worker.buttonTakeawaysTitle))
        return items
    }

    private func takeawayItems(from sprint: QDMSprint) -> [MySprintDetailsItem] {
        var items = [MySprintDetailsItem]()
        // Highlights
        items.append(MySprintDetailsItem(type: .header(action: .highlights), text: worker.headerHighlights))
        items.append(MySprintDetailsItem(type: .listItem(appearance: .regular), text: sprint.notesLearnings ?? ""))
        // Strategies
        items.append(MySprintDetailsItem(type: .header(action: .strategies), text: worker.headerStrategies))
        items.append(MySprintDetailsItem(type: .listItem(appearance: .regular), text: sprint.notesReflection ?? ""))
        // Benefits
        items.append(MySprintDetailsItem(type: .header(action: .benefits), text: worker.headerBenefits))
        items.append(MySprintDetailsItem(type: .listItem(appearance: .regular), text: sprint.notesBenefits ?? ""))
        return items
    }

    private func bottomButtons(for sprint: QDMSprint) -> [SprintButtonParameters]? {
        switch worker.sprintStatus {
        case .upcoming:
            return [startSprintButton]
        case .active:
            return [pauseSprintButton]
        case .paused:
            return [continueSprintButton]
        case .completed:
            return [startSprintButton]
        }
    }
}

// MARK: - Private methods

extension MySprintDetailsInteractor {
    private func titles(for items: [QDMContentItem]) -> [String] {
        return items.sorted(by: { $0.sortOrder < $1.sortOrder }).compactMap { $0.valueText }
    }

    private func updateSprintReflection(_ type: MySprintDetailsItem.Action) {
        router.presentNoteEditing(for: worker.sprint, action: type)
    }

    private func showSprintInProgressAlert(with endDate: Date) {
        let text = worker.infoSprintInProgressMessage(endDate: endDate)
        let infoViewModel = MySprintsInfoAlertViewModel(isFullscreen: true,
                                                        style: .regular,
                                                        icon: R.image.my_library_warning() ?? UIImage(),
                                                        title: worker.infoSprintInProgressTitle,
                                                        message: NSAttributedString(string: text),
                                                        transparent: true)
        let rightButtons = [continuePreviousActionButton, cancelButton]
        show(infoViewModel, rightButtons)
    }

    private func showPauseSprintAlert() {
        let text = worker.infoPauseSprintMessage
        let infoViewModel = MySprintsInfoAlertViewModel(isFullscreen: true,
                                                        style: .regular,
                                                        icon: R.image.my_library_warning() ?? UIImage(),
                                                        title: worker.infoPauseSprintTitle,
                                                        message: NSAttributedString(string: text),
                                                        transparent: false)
        let rightButtons = [yesPauseButton, cancelButton]
        show(infoViewModel, rightButtons)
    }

    private func showContinueSprintAlert() {
        let text = worker.infoReplanSprintMessage
        let infoViewModel = MySprintsInfoAlertViewModel(isFullscreen: true,
                                                        style: .halfScreenBlur,
                                                        icon: R.image.my_library_warning() ?? UIImage(),
                                                        title: worker.infoReplanSprintTitle,
                                                        message: NSAttributedString(string: text),
                                                        transparent: false)
        let rightButtons = [restartPausedButton, continuePausedButton]
        show(infoViewModel, rightButtons)
    }

    private func show(_ infoViewModel: MySprintsInfoAlertViewModel, _ rightButtons: [SprintButtonParameters]) {
        viewModel.infoViewModel = infoViewModel
        viewModel.showDismissButton = false
        viewModel.rightButtons = rightButtons
        presenter.present()
    }

    private func checkSprintInProgress(with action: @escaping () -> Void) {
        worker.anySprintInProgress { [weak self] (inProgress, date) in
            if inProgress, let date = date {
                self?.actionToContinueOnActiveSprint = action
                self?.showSprintInProgressAlert(with: date)
            } else {
                action()
            }
        }
    }

    @objc private func didUpdateSprintDetails(_ notification: Notification) {
        guard let sprint = notification.userInfo?[Notification.Name.MySprintDetailsKeys.sprint] as? QDMSprint,
            sprint.qotId == worker.sprint.qotId else {
            return
        }
        worker.setSprint(sprint)
        viewModel = viewModel(from: worker.sprint)
        presenter.present()
    }
}
