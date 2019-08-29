//
//  MySprintsListViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintsListViewController: UIViewController, ScreenZLevel2 {

    // MARK: - Properties

    var interactor: MySprintsListInteractorInterface?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerHeight: NSLayoutConstraint!

    private var infoAlertView: InfoAlertView?
    private var bottomNavigationItems = UINavigationItem()

    // MARK: - Init

    init(configure: Configurator<MySprintsListViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MySprintsListConfigurator.make()
        configurator(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.addHeader(with: .level2)
        interactor?.viewDidLoad()
        self.showLoadingSkeleton(with: [.oneLineHeading, .padHeading, .padHeading, .padHeading, .myPrepsCell])

        ThemeTint.accent.apply(editButton)
        editButton.setImage(R.image.ic_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)
        setEditButton(enabled: true)
    }

    override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.leftBarButtonItems
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.rightBarButtonItems
    }
}

// MARK: - Private

private extension MySprintsListViewController {
    private func showDefaultBottomButtons() {
        // Do not reload if not displayed
        if self.viewIfLoaded?.window == nil {
            return
        }
        bottomNavigationItems.leftBarButtonItems = [backNavigationItem()]
        bottomNavigationItems.rightBarButtonItems = nil
        refreshBottomNavigationItems()
    }

    private func showBottomButtons(_ buttons: [ButtonParameters]) {
        bottomNavigationItems.leftBarButtonItems = nil
        bottomNavigationItems.rightBarButtonItems = buttons.map {
            let button = RoundedButton.barButton(title: $0.title, target: $0.target, action: $0.action)
            button.isEnabled = $0.isEnabled
            return button
        }
        refreshBottomNavigationItems()
    }

    private func updateInfoViewWithViewModel(_ model: MySprintsInfoAlertViewModel?) {
        guard let model = model else {
            infoAlertView?.dismiss()
            infoAlertView = nil
            return
        }

        infoAlertView = InfoAlertView()
        infoAlertView?.set(icon: model.icon, title: model.title, attributedText: model.message)
        infoAlertView?.present(on: self.view)
        infoAlertView?.topInset = model.isFullscreen ? 0 : headerHeight.constant
        infoAlertView?.bottomInset = BottomNavigationContainer.height
        infoAlertView?.setBackgroundColor(self.view.backgroundColor)
    }

    private func setEditButton(enabled: Bool) {
        editButton.isEnabled = enabled
        let color = enabled ? UIColor.accent : UIColor.sand08
        let borderColor = enabled ? UIColor.accent40 : UIColor.sand08
        editButton.layer.borderColor = borderColor.cgColor
        editButton.tintColor = color
    }
}

// MARK: - Actions

private extension MySprintsListViewController {
    @IBAction func didTapEditButton() {
        interactor?.didTapEdit()
    }
}

// MARK: - MySprintsListViewControllerInterface

extension MySprintsListViewController: MySprintsListViewControllerInterface {
    func update() {
        titleLabel.text = interactor?.title ?? ""

        let isEditing = interactor?.viewModel.isEditing ?? false
        tableView.setEditing(isEditing, animated: true)
        editButton.isHidden = !(interactor?.viewModel.shouldShowEditButton ?? true)
        setEditButton(enabled: interactor?.viewModel.canEdit ?? false)

        updateInfoViewWithViewModel(interactor?.viewModel.infoViewModel)
        if let bottomButtons = interactor?.viewModel.bottomButtons {
            showBottomButtons(bottomButtons)
        } else {
            showDefaultBottomButtons()
        }
    }

    func reloadData() {
        tableView.reloadData()
        self.removeLoadingSkeleton()
    }

    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem]) {
        QOTAlert.show(title: title, message: message, bottomItems: buttons)
    }
}

// MARK: - UITableViewDataSource

extension MySprintsListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.viewModel.displayData.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < (interactor?.viewModel.displayData.count ?? 0) else { return 0 }
        return interactor?.viewModel.displayData[section].items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.viewModel.item(at: indexPath) else { return UITableViewCell() }
        let sprintCell: MySprintsListTableViewCell = tableView.dequeueCell(for: indexPath)
        sprintCell.set(title: item.title, status: item.status, description: item.statusDescription, progress: item.progress)
        return sprintCell
    }
}

// MARK: - UITableViewDelegate

extension MySprintsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing, let selectedPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedPath, animated: true)
        }

        _ = interactor?.handleSelectedItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard tableView.isEditing else { return }
        _ = interactor?.handleSelectedItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = interactor?.viewModel.displayData[section] else { return nil }
        return MySprintsListHeaderView.instantiateFromNib(title: item.title, isActive: item.isActive)
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath {
            return
        }
        interactor?.moveItem(at: sourceIndexPath, to: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard tableView.isEditing, let item = interactor?.viewModel.item(at: indexPath) else { return false }
        return item.isReordable
    }

    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // Forbid moving cells between sections
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        // Forbid moving cells in place of active sprints
        if let item = interactor?.viewModel.item(at: proposedDestinationIndexPath) {
            return item.isReordable ? proposedDestinationIndexPath : sourceIndexPath
        }
        return proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard tableView.isEditing, let item = interactor?.viewModel.item(at: indexPath) else { return false }
        return item.isRemovable
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard tableView.isEditing, let item = interactor?.viewModel.item(at: indexPath) else { return true }
        return item.isRemovable
    }
}
