//
//  MyLibraryUserStorageViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryUserStorageViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MyLibraryUserStorageInteractorInterface?

    @IBOutlet private weak var headerHeight: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var addButton: RoundedButton!

    private var bottomNavigationItems = UINavigationItem()
    private var infoAlertView: InfoAlertView?

    // MARK: - Init

    init(configure: Configurator<MyLibraryUserStorageViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        interactor?.viewDidLoad()
        view.backgroundColor = .carbon

        editButton.tintColor = .accent
        editButton.setImage(R.image.ic_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.isHidden = !(interactor?.showAddButton ?? false)
        addButton.setTitle(" " + (interactor?.addTitle ?? ""), for: .normal)
        addButton.setImage(R.image.my_library_note()?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.setImage(R.image.my_library_note_light()?.withRenderingMode(.alwaysTemplate), for: .disabled)
    }

    override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.leftBarButtonItems
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.rightBarButtonItems
    }
}

// MARK: - Private

private extension MyLibraryUserStorageViewController {

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

    private func updateInfoViewWithViewModel(_ model: MyLibraryUserStorageInfoViewModel?) {
        guard let model = model else {
            infoAlertView?.dismiss()
            infoAlertView = nil
            return
        }

        if infoAlertView == nil {
            infoAlertView = InfoAlertView()
            infoAlertView?.present(on: self.view)
        }
        infoAlertView?.set(icon: model.icon, title: model.title, attributedText: model.message)
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

private extension MyLibraryUserStorageViewController {
    @IBAction func didTapEditButton(sender: UIButton) {
        interactor?.didTapEdit(isEditing: true)
    }

    @IBAction func didTapAddNote(sender: RoundedButton!) {
        interactor?.didTapAddNote()
    }

    @IBAction func didTapPlayButton(sender: UIButton) {
        interactor?.didTapPlayItem(at: sender.tag)
    }
}

// MARK: - MyLibraryUserStorageViewControllerInterface

extension MyLibraryUserStorageViewController: MyLibraryUserStorageViewControllerInterface {
    func update() {
        let isEditing = interactor?.isEditing ?? false

        titleLabel.text = interactor?.title
        editButton.isHidden = !(interactor?.showEditButton ?? true)
        setEditButton(enabled: interactor?.canEdit ?? false)
        addButton.isEnabled = !isEditing

        tableView.allowsMultipleSelection = isEditing
        tableView.setEditing(isEditing, animated: true)

        updateInfoViewWithViewModel(interactor?.infoViewModel)
        if let bottomButtons = interactor?.bottomButtons {
            showBottomButtons(bottomButtons)
        } else {
            showDefaultBottomButtons()
        }
    }

    func reloadData() {
        tableView.reloadData()
    }

    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem]) {
        QOTAlert.show(title: title, message: message, bottomItems: buttons)
    }
}

// MARK: - UITableViewDataSource
extension MyLibraryUserStorageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = interactor?.items[indexPath.row]
        let cellType = item?.cellType ?? MyLibraryCellViewModel.CellType.NOTE
        let placeholder = UIImage(named: "preloading")

        var returnCell: BaseMyLibraryTableViewCellInterface?
        switch cellType {
        case .VIDEO:
            let cell: VideoBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.preview.setImage(from: item?.previewURL, placeholder: placeholder)
            returnCell = cell
        case .AUDIO:
            let cell: AudioBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.preview.setImage(from: item?.previewURL, placeholder: placeholder)
            cell.playButton.setTitle(item?.duration, for: .normal)
            cell.playButton.tag = indexPath.row
            returnCell = cell
        case .ARTICLE:
            let cell: ArticleBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.preview.setImage(from: item?.previewURL, placeholder: placeholder)
            returnCell = cell
        case .NOTE:
            let cell: NoteTableViewCell = tableView.dequeueCell(for: indexPath)
            returnCell = cell
        case .DOWNLOAD:
            let cell: DownloadTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setStatus(item?.downloadStatus ?? .none)
            returnCell = cell
        }
        returnCell?.setTitle(item?.title)
        returnCell?.icon.image = item?.icon
        returnCell?.setInfoText(item?.description)

        return returnCell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension MyLibraryUserStorageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = interactor?.handleSelectedItem(at: indexPath.row)
        if tableView.isEditing == false {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard tableView.isEditing else {
            return
        }
        _ = interactor?.handleSelectedItem(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
