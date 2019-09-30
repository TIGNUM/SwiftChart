//
//  MySprintsListInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintsListInteractor {

    // MARK: - Properties

    private let worker: MySprintsListWorker
    private let presenter: MySprintsListPresenterInterface
    private let router: MySprintsListRouterInterface
    private let notificationCenter: NotificationCenter

    private (set) var viewModel = MySprintsListViewModel()

    private var items = [QDMSprint]()
    private var identifiersForCheck = Set<String>()
    private var reorderedDisplayData = [MySprintsListDataViewModel]()
    private var isEditing: Bool = false {
        didSet {
            viewModel.isEditing = self.isEditing
            viewModel.shouldShowEditButton = shouldshowEditButton
            viewModel.canEdit = canEdit
        }
    }

    // Cannot be lazy as "Remove" state depends on selected items count
    private var preRemoveButtons: [ButtonParameters] {
        return [ButtonParameters(title: worker.removeTitle,
                                 target: self,
                                 action: #selector(removeItemsTapped),
                                 isEnabled: !(identifiersForCheck.count == 0)),
                ButtonParameters(title: worker.cancelTitle, target: self, action: #selector(cancelEditingTapped))]
    }
    private lazy var removeButtons: [UIBarButtonItem] = {
        return [RoundedButton(title: worker.cancelTitle, target: self, action: #selector(cancelRemovingTapped)).barButton,
                RoundedButton(title: worker.continueTitle, target: self, action: #selector(continueRemovingTapped)).barButton]
    }()

    private lazy var reorderingButtons: [ButtonParameters] = {
        return [ButtonParameters(title: worker.saveTitle, target: self, action: #selector(saveReorderingTapped(_:))),
                ButtonParameters(title: worker.cancelTitle, target: self, action: #selector(cancelEditingTapped))]
    }()

    private lazy var emptyDataAlert: MySprintsInfoAlertViewModel = {
        return MySprintsInfoAlertViewModel(isFullscreen: false,
                                           style: .regular,
                                           icon: R.image.my_sprints_completed() ?? UIImage(),
                                           title: self.worker.emptyContentAlertTitle,
                                           message: self.worker.emptyContentAlertMessage,
                                           transparent: false)
    }()

    private lazy var monthsFormatter: DateFormatter = {
        return DateFormatter.ddMMM
    }()

    // MARK: - Init

    init(worker: MySprintsListWorker,
         presenter: MySprintsListPresenterInterface,
         router: MySprintsListRouterInterface,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.notificationCenter = notificationCenter

        notificationCenter.addObserver(self, selector: #selector(load), name: .didUpdateMySprintsData, object: nil)
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
        load()
    }
}

// MARK: - MySprintsListInteractorInterface

extension MySprintsListInteractor: MySprintsListInteractorInterface {

    func getSprint() -> QDMSprint {
        return worker.getSprint()
    }

    var title: String {
        return isEditing ? worker.editingTitle : worker.title
    }

    func didTapEdit() {
        isEditing = true
        viewModel.bottomButtons = preRemoveButtons
        presenter.present()
    }

    func handleSelectedItem(at indexPath: IndexPath) -> Bool {
        guard let item = viewModel.item(at: indexPath) else {
            return false
        }
        if isEditing {
            return checkItemForDeletion(item)
        } else {
            return openItemDetails(item)
        }
    }

    func moveItem(at source: IndexPath, to destination: IndexPath) {
        if reorderedDisplayData.isEmpty {
            reorderedDisplayData.append(contentsOf: viewModel.displayData)
        }

        var items = reorderedDisplayData[source.section].items
        let item = items[source.row]
        items.remove(at: source.row)
        items.insert(item, at: destination.row)
        self.reorderedDisplayData[source.section].items = items

        // Remove items funtionality has priority over reordering
        if identifiersForCheck.count == 0 {
            viewModel.bottomButtons = reorderingButtons
            presenter.present()
        }
    }
}

// MARK: - Private methods

extension MySprintsListInteractor {

    private var shouldshowEditButton: Bool {
        return !(isEditing || viewModel.displayData.isEmpty || viewModel.infoViewModel != nil)
    }

    private var canEdit: Bool {
        // Cannot edit if already editing OR there is no data which can be removed
        // (Reordering can only be done for upcoming items, which are also removable)
        return !(isEditing || viewModel.displayData.allSatisfy { $0.items.filter { $0.isRemovable }.isEmpty })
    }

    @objc private func load() {
        items.removeAll()
        worker.loadData { [weak self] (initiated, sprints) in
            guard let strongSelf = self else { return }
            if !initiated || sprints.isEmpty {
                strongSelf.viewModel.infoViewModel = strongSelf.emptyDataAlert
            } else {
                strongSelf.items.append(contentsOf: sprints)
                strongSelf.handle(sprints: strongSelf.items)
            }
            strongSelf.isEditing = false
            strongSelf.presenter.present()
            strongSelf.presenter.presentData()
        }
    }

    private func handle(sprints: [QDMSprint]) {
        viewModel.displayData.removeAll()
        let items = sort(sprints: sprints.compactMap { sprintViewModel(from: $0) })

        var pending = [MySprintsListSprintModel]()
        // Active, upcoming & paused
        pending.append(contentsOf: items.filter {
            switch $0.status {
            case .completed:
                return false
            case .active, .upcoming, .paused:
                return true
            }
        })
        if !pending.isEmpty {
            viewModel.displayData.append(MySprintsListDataViewModel(title: worker.sprintPlanHeader, isActive: true, items: pending))
        }

        // Completed
        let completed = sort(sprints: items.filter {
            switch $0.status {
            case .completed(on: _):
                return true
            case .active, .upcoming, .paused(on: _):
                return false
            }
        })
        if !completed.isEmpty {
            viewModel.displayData.append(MySprintsListDataViewModel(title: worker.completeHeader, isActive: false, items: completed))
        }
    }

    private func sort(sprints: [MySprintsListSprintModel]) -> [MySprintsListSprintModel] {
        return sprints.sorted(by: {
            switch ($0.status, $1.status) {
                // Active
            case (.active, _):
                return true
            case (_, .active):
                return false
                // Paused
            case (.paused(on: let date1), .paused(on: let date2)):
                return date1 < date2
            case (.paused, _):
                return true
            case (_, .paused):
                return false
                // Completed
            case (.completed(on: let date1), .completed(on: let date2)):
                return date1 > date2
                // Upcoming
            default:
                if $0.orderingNumber != $1.orderingNumber {
                    return $0.orderingNumber < $1.orderingNumber
                }
                return $0.createdDate < $1.createdDate
            }
        })
    }

    private func checkItemForDeletion(_ item: MySprintsListSprintModel) -> Bool {
        let previouslySelected = identifiersForCheck.contains(item.identifier)
        if !previouslySelected {
            identifiersForCheck.insert(item.identifier)
        } else {
            identifiersForCheck.remove(item.identifier)
        }

        if identifiersForCheck.count == 0 && !reorderedDisplayData.isEmpty {
            viewModel.bottomButtons = reorderingButtons
        } else {
            viewModel.bottomButtons = preRemoveButtons
        }
        presenter.present()
        return !previouslySelected
    }

    private func openItemDetails(_ item: MySprintsListSprintModel) -> Bool {
        guard let sprint = worker.getSprint(with: item.identifier) else {
            return false
        }
        router.presentSprint(sprint)
        return true
    }

    private func saveReorderedItems(_ reorderedItems: [MySprintsListDataViewModel]) {
        // Save new indexes to actual QDMSprint objects
        let flatItems = reorderedItems.compactMap { $0.items }.flatMap { $0 }
        for (index, item) in flatItems.enumerated() {
            guard let sprintIndex = self.items.firstIndex(where: { $0.qotId == item.identifier }) else { continue }
            self.items[sprintIndex].sortOrder = index
        }
        // Save `QDMSprint`s to backend
        worker.save(sprints: self.items) { [weak self] (sprints, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                qot_dal.log("Saved updating sprints: \(error)", level: .error)
                return
            }
            guard let sprints = sprints else { return }
            strongSelf.reorderedDisplayData.removeAll()
            strongSelf.items.removeAll()
            strongSelf.items.append(contentsOf: sprints)

            strongSelf.endEditing()
            strongSelf.handle(sprints: strongSelf.items)
            strongSelf.presenter.present()
            strongSelf.presenter.presentData()
        }
    }

    private func sprintViewModel(from sprint: QDMSprint) -> MySprintsListSprintModel {
        let statusTuple = status(from: sprint)
        return MySprintsListSprintModel(
            title: sprint.title ?? String(describing: sprint.createdAt!),
            status: statusTuple.0,
            progress: "\(sprint.currentDay)/\(sprint.maxDays)",
            statusDescription: statusTuple.1,
            identifier: sprint.qotId ?? "-",
            createdDate: sprint.createdAt ?? Date(),
            completedDate: sprint.completedAt,
            orderingNumber: sprint.sortOrder)
    }

    private func status(from sprint: QDMSprint) -> (MySprintStatus, String) {
        let status = MySprintStatus.from(sprint)
        let text: String
        switch status {
        case .active: text = worker.statusActive
        case .paused: text = worker.statusPaused
        case .completed:
            let completionDate = sprint.completedAt ?? Date()
            text = worker.statusCompleted + " " + "\(monthsFormatter.string(from: completionDate))"
        case .upcoming: text = worker.statusUpcoming
        }
        return (status, text)
    }

    func continueRemovingItems(_ sprints: [QDMSprint]) {
        worker.remove(sprints: sprints) { [weak self] (error) in
            if let error = error {
                qot_dal.log("Failed to remove sprints. Error \(error)")
                return
            }
            guard let strongSelf = self else { return }
            strongSelf.viewModel.displayData.removeAll()
            strongSelf.endEditing()
            strongSelf.presenter.present()
            strongSelf.presenter.presentData()
            strongSelf.load()
        }
    }

    func endEditing() {
        isEditing = false
        viewModel.bottomButtons = nil
        viewModel.infoViewModel = nil
        identifiersForCheck.removeAll()
        reorderedDisplayData.removeAll()
    }
}

// MARK: - Info view's button actions

extension MySprintsListInteractor {
    @objc private func cancelEditingTapped() {
        let didReorderData = !reorderedDisplayData.isEmpty
        endEditing()
        presenter.present()
        if didReorderData {
            presenter.presentData()
        }
    }

    @objc private func removeItemsTapped() {
        presenter.presentAlert(title: worker.removeItemsAlertTitle,
                               message: worker.removeItemsAlertMessage,
                               buttons: removeButtons)
    }

    @objc private func cancelRemovingTapped() {
        // nop
    }

    @objc private func continueRemovingTapped() {
        let sprintsForRemoval = items.filter { identifiersForCheck.contains($0.qotId ?? "") }
        if sprintsForRemoval.isEmpty {
            return
        }
        continueRemovingItems(sprintsForRemoval)
    }

    @objc private func saveReorderingTapped(_ sender: UIButton) {
        guard !reorderedDisplayData.isEmpty else { return }
        sender.isEnabled = false
        saveReorderedItems(reorderedDisplayData)
    }
}
