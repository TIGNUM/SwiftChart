//
//  BookMarkSelectionViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BookMarkSelectionViewController: BaseViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: RoundedButton!
    var interactor: BookMarkSelectionInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Private

private extension BookMarkSelectionViewController {

    func setupView() {
        tableView?.registerDequeueable(BookMarkSelectionCell.self)
        titleLabel.text = "CHOOSE A LIBRARY" // FIXME: use appText
        ThemableButton.fullscreenVideoPlayerDownload.apply(saveButton, title: "Save") // FIXME: use appText

        // FIXME: set styles
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
        // FIXME: set styles
        if let team = model.team {
            cell.teamLibraryName.text = team.name
            cell.participantsLabel.text = "\(team.memberCount)" // FIXME: use appText
        } else {
            cell.teamLibraryName.text = "My Library" // FIXME: use appText
            cell.participantsLabel.text = "Private" // FIXME: use appText
        }
        if model.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        cell.isUserInteractionEnabled = model.canEdit

        return cell
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
