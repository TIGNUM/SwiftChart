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

    var interactor: MyLibraryUserStorageInteractorInterface!

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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: .zero)

        ThemeButton.editButton.apply(editButton)
        editButton.setImage(R.image.ic_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)
        ThemeTint.white.apply(editButton.imageView ?? UIImageView.init())

        interactor.viewDidLoad()
        tableView.registerDequeueable(ArticleBookmarkTableViewCell.self)
        tableView.registerDequeueable(VideoBookmarkTableViewCell.self)
        tableView.registerDequeueable(AudioBookmarkTableViewCell.self)
        tableView.registerDequeueable(NoteTableViewCell.self)
        tableView.registerDequeueable(DownloadTableViewCell.self)
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = .zero
        pageTrack.pageKey = pageKey
        if let teamId = interactor?.teamId {
            pageTrack.associatedValueId = teamId
            pageTrack.associatedValueType = .TEAM
        }
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
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
            ThemeButton.carbonButton.apply(button)
            button.setTitle($0.title)
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
        infoAlertView?.topInset = model.isFullscreen ? .zero : headerViewHeightConstraint.constant
        infoAlertView?.bottomInset = BottomNavigationContainer.height
        infoAlertView?.setBackgroundColor(self.view.backgroundColor)
    }

    private func setEditButton(enabled: Bool) {
        editButton.isEnabled = enabled
        let color = enabled ? UIColor.white : UIColor.lightGrey
        let borderColor = enabled ? UIColor.white : UIColor.clear
        editButton.layer.borderColor = borderColor.cgColor
        editButton.tintColor = color
    }
}

// MARK: - Actions

private extension MyLibraryUserStorageViewController {
    @IBAction func didTapEditButton(sender: UIButton) {
        interactor.didTapEdit(isEditing: true)
        trackUserEvent(.EDIT, stringValue: interactor.itemType.rawValue, valueType: .EDIT_LIBRARY, action: .TAP)
    }

    @IBAction func didTapAddNote(sender: RoundedButton!) {
        interactor.didTapAddNote()
    }

    @IBAction func didTapPlayButton(sender: UIButton) {
        interactor.didTapPlayItem(at: sender.tag)
    }
}

// MARK: - MyLibraryUserStorageViewControllerInterface

extension MyLibraryUserStorageViewController: MyLibraryUserStorageViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(view)
        tableView.allowsSelection = false
        addButtonWidthConstraint.constant = interactor.showAddButton ? 80 : 0.0
        addButton.setImage(R.image.ic_note()?.withRenderingMode(.alwaysTemplate), for: .normal)
        ThemeTint.white.apply(addButton.imageView ?? UIImageView.init())
        addButton.setImage(R.image.ic_note()?.withRenderingMode(.alwaysTemplate), for: .disabled)
        ThemeButton.carbonButton.apply(addButton)
        addButton.setTitle(" " + interactor.addTitle)
        // (interactor.items == nil) means, need to show skeleton
        tableView.isHidden = interactor.items == nil ? false : (interactor.items?.count ?? .zero) == .zero
    }

    func update() {
        let isEditing = interactor.isEditing
        ThemeText.myLibraryItemsTitle.apply(interactor.title, to: baseHeaderView?.titleLabel)
        baseHeaderView?.configure(title: interactor.title.lowercased().capitalizingFirstLetter(), subtitle: interactor.subtitle)
        headerViewHeightConstraint.constant = (baseHeaderView?.calculateHeight(for: view.frame.size.width) ?? .zero) + 10
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        editButtonWidthConstraint.constant = interactor.showEditButton ? 40.0 : 0.0
        setEditButton(enabled: interactor.canEdit)
        addButton.isHidden = isEditing

        // (interactor.items == nil) means, need to show skeleton
        tableView.isHidden = interactor.items == nil ? false : (interactor.items?.count ?? .zero) == .zero
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = isEditing
        tableView.setEditing(isEditing, animated: true)

        updateInfoViewWithViewModel(interactor.infoViewModel)
        if let bottomButtons = interactor.bottomButtons {
            showBottomButtons(bottomButtons)
        } else {
            showDefaultBottomButtons()
        }
        if isEditing, let items = interactor.items {
            for (index, item) in items.enumerated() where interactor.getIdentifiersForCheckedItems().contains(item.identifier) {
                let indexPath = IndexPath(row: index, section: .zero)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
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
        guard let items = interactor.items else {
            return 1
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = interactor.items, items.count > .zero,
            let item = interactor.items?[indexPath.row] else {
            let cell = UITableViewCell()
            cell.backgroundColor = .black
                return cell
        }
        return LibraryTableViewCellFactory.cellForStorageItem(tableView, indexPath, item)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let items = interactor.items, items.count > 0,
            let item = interactor.items?[indexPath.row] {
            return item.removable
        }
        return false
    }
}

// MARK: - UITableViewDelegate
extension MyLibraryUserStorageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if interactor.handleSelectedItem(at: indexPath.row) == false {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard tableView.isEditing else {
            return
        }
        _ = interactor.handleSelectedItem(at: indexPath.row)
    }
}

extension MyLibraryUserStorageViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler = appDelegate.backgroundCompletionHandler {
                appDelegate.backgroundCompletionHandler = nil
                backgroundCompletionHandler()
            }
        }
    }
}
