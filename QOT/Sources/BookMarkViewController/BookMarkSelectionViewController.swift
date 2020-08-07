//
//  BookMarkSelectionViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BookMarkSelectionViewController: BaseViewController, ScreenZLevelIgnore {
    let tableViewCellHeight: CGFloat = 75
    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: RoundedButton!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!

    var interactor: BookMarkSelectionInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .hideBottomNavigation, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // if table view is too long
        let maxTableViewHeight = view.frame.size.height * 0.5
        var expectedTableViewHeight = CGFloat(interactor?.viewModels.count ?? 0) * tableViewCellHeight
        if expectedTableViewHeight > maxTableViewHeight {
            expectedTableViewHeight = maxTableViewHeight
        }
        if tableViewHeightConstraint.constant != expectedTableViewHeight {
            tableViewHeightConstraint.constant = expectedTableViewHeight
            tableView.needsUpdateConstraints()
        }
    }
}

// MARK: - Private

private extension BookMarkSelectionViewController {

    func setupView() {
        tableView?.registerDequeueable(BookMarkSelectionCell.self)
        ThemeText.myLibraryGroupName.apply(interactor?.headerTitle ?? "CHOOSE A LIBRARY", to: titleLabel)
        ThemableButton.myLibrary.apply(saveButton, title: interactor?.saveButtonTitle ?? "Save")
    }
}

// MARK: - Actions

private extension BookMarkSelectionViewController {
    @IBAction func didTapSaveButton(_ sender: Any?) {
        trackUserEvent(.SAVE, value: nil, stringValue: nil, valueType: nil, action: .TAP)
        interactor?.save()
    }

    @IBAction func dismiss(_ sender: Any?) {
        if (sender as? UITapGestureRecognizer) != nil {
            trackUserEvent(.CLOSE, value: nil, stringValue: nil, valueType: nil, action: .TAP)
        } else {
            trackUserEvent(.CLOSE, value: nil, stringValue: nil, valueType: nil, action: .SWIPE)
        }
        interactor?.dismiss()
    }
}

// MARK: - BookMarkSelectionViewControllerInterface

extension BookMarkSelectionViewController: BookMarkSelectionViewControllerInterface {
    func loadData() {
        tableView?.reloadData()
        view.setNeedsLayout()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension BookMarkSelectionViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.viewModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookMarkSelectionCell = tableView.dequeueCell(for: indexPath)
        cell.selectionStyle = .none
        cell.separator.isHidden = indexPath.row == 0
        guard let viewModels = interactor?.viewModels, viewModels.count > indexPath.row,
            let model = viewModels.at(index: indexPath.row) else { return cell }
        if let team = model.team {
            ThemeText.myLibraryItemsTitle.apply(team.name, to: cell.teamLibraryName)
            let membersString = interactor?.memberCountTemplateString.replacingOccurrences(of: "($count)", with: "\(team.memberCount)")
            ThemeText.asterixText.apply(membersString, to: cell.participantsLabel)

        } else {
            ThemeText.myLibraryItemsTitle.apply(interactor?.myLibraryCellTitle ?? "", to: cell.teamLibraryName)
            ThemeText.asterixText.apply(interactor?.myLibraryCellSubtitle ?? "", to: cell.participantsLabel)
        }
        if model.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        cell.isUserInteractionEnabled = model.canEdit

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModels = interactor?.viewModels, viewModels.count > indexPath.row,
            let model = viewModels.at(index: indexPath.row) else { return }
        interactor?.didTapItem(index: indexPath.row)
        trackUserEvent(.SELECT, value: model.team?.remoteID, stringValue: nil, valueType: .TEAM, action: .TAP)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let viewModels = interactor?.viewModels, viewModels.count > indexPath.row,
            let model = viewModels.at(index: indexPath.row) else { return }
        interactor?.didTapItem(index: indexPath.row)
        trackUserEvent(.DESELECT, value: model.team?.remoteID, stringValue: nil, valueType: .TEAM, action: .TAP)
    }
}
