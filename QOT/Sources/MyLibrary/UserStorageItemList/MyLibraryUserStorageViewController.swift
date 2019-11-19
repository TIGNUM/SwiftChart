//
//  MyLibraryUserStorageViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import Kingfisher

final class MyLibraryUserStorageViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MyLibraryUserStorageInteractorInterface?

    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var editButton: RoundedButton!
    @IBOutlet private weak var addButton: RoundedButton!
    @IBOutlet weak var addButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButtonWidthConstraint: NSLayoutConstraint!

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
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)

        ThemeButton.editButton.apply(editButton)
        editButton.setImage(R.image.ic_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)

        interactor?.viewDidLoad()
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
            let button = RoundedButton(title: $0.title, target: $0.target, action: $0.action)
            button.isEnabled = $0.isEnabled
            ThemableButton.myLibrary.apply(button, title: $0.title)
            return button.barButton
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
        infoAlertView?.topInset = model.isFullscreen ? 0 : headerViewHeightConstraint.constant
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
        trackUserEvent(.EDIT, stringValue: interactor?.itemType.rawValue, valueType: .EDIT_LIBRARY, action: .TAP)
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
    func setupView() {
        ThemeView.level3.apply(view)
        tableView.allowsSelection = false
        addButtonWidthConstraint.constant = (interactor?.showAddButton ?? false) ? 80 : 0.0
        addButton.setImage(R.image.my_library_note()?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.setImage(R.image.my_library_note_light()?.withRenderingMode(.alwaysTemplate), for: .disabled)
        ThemableButton.myLibrary.apply(addButton, title: " " + (interactor?.addTitle ?? ""))
        // (interactor?.items == nil) means, need to show skeleton
        tableView.isHidden = interactor?.items == nil ? false : (interactor?.items?.count ?? 0) == 0
    }

    func update() {
        baseHeaderView?.configure(title: interactor?.title, subtitle: nil)
        ThemeText.myLibraryItemsTitle.apply(interactor?.title, to: baseHeaderView?.titleLabel)

        let isEditing = interactor?.isEditing ?? false
        editButtonWidthConstraint.constant = (interactor?.showEditButton ?? true) ? 40.0 : 0.0
        setEditButton(enabled: interactor?.canEdit ?? false)
        addButton.isEnabled = !isEditing

        // (interactor?.items == nil) means, need to show skeleton
        tableView.isHidden = interactor?.items == nil ? false : (interactor?.items?.count ?? 0) == 0
        tableView.allowsSelection = true
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
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }

    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem]) {
        QOTAlert.show(title: title, message: message, bottomItems: buttons)
    }
}

// MARK: - UITableViewDataSource
extension MyLibraryUserStorageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = interactor?.items else {
            return 1
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: MyLibraryCellViewModel? = nil
        if let items = interactor?.items, items.count > 0 {
            item = interactor?.items?[indexPath.row]
        }

        let cellType = item?.cellType ?? MyLibraryCellViewModel.CellType.DOWNLOAD

        var returnCell: BaseMyLibraryTableViewCell?
        switch cellType {
        case .VIDEO:
            let cell: VideoBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(withUrl: item?.previewURL)

            returnCell = cell
        case .AUDIO:
            let cell: AudioBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(playButtonTitle: item?.duration, playButtonTag: indexPath.row)

            returnCell = cell
        case .ARTICLE:
            let cell: ArticleBookmarkTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(previewImageUrl: item?.previewURL)

            returnCell = cell
        case .NOTE:
            let cell: NoteTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure()

            returnCell = cell
        case .DOWNLOAD:
            let cell: DownloadTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure()

            if let itemModel = item {
                cell.setStatus(itemModel.downloadStatus)
            }

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
