//
//  MyLibraryBookmarksInteractor.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryUserStorageInteractor {

    // MARK: - Properties

    private let worker: MyLibraryUserStorageWorker
    private let presenter: MyLibraryUserStoragePresenterInterface
    private let router: MyLibraryUserStorageRouterInterface
    private let team: QDMTeam?
    private let targetCategory: String?
    private let notificationCenter: NotificationCenter

    private (set) var isEditing: Bool = false
    private (set) var infoViewModel: MyLibraryUserStorageInfoViewModel?
    private (set) var bottomButtons: [ButtonParameters]?

    var items: [MyLibraryCellViewModel]?
    private var identifiersForCheck = Set<String>()
    private var itemForDownload: MyLibraryCellViewModel?

    private var viewModelConverter = MyLibraryCellViewModelConverter()
    private var hasRemovableItem = false

    // Cannot be lazy as "Remove" state depends on selected items count
    private var editingButtons: [ButtonParameters] {
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

    private lazy var cancelDownloadButtons: [UIBarButtonItem] = {
        return [RoundedButton(title: worker.cancelTitle, target: self, action: #selector(cancelCancelingDownloadTapped)).barButton,
                RoundedButton(title: worker.continueTitle, target: self, action: #selector(continueCancelingDownloadTapped)).barButton]
    }()

    private lazy var cellularDownloadButtons: [UIBarButtonItem] = {
        return [RoundedButton(title: worker.cancelTitle, target: self, action: #selector(cancelCellularDownload)).barButton,
                RoundedButton(title: worker.continueTitle, target: self, action: #selector(continueCellularDownload)).barButton]
    }()

    // MARK: - Init

    init(team: QDMTeam?,
         category: String?,
         worker: MyLibraryUserStorageWorker,
         presenter: MyLibraryUserStoragePresenterInterface,
         router: MyLibraryUserStorageRouterInterface,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.team = team
        self.targetCategory = category
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.notificationCenter = notificationCenter

        self.notificationCenter.addObserver(self,
                                            selector: #selector(load(_:)),
                                            name: UIApplication.didBecomeActiveNotification, object: nil)
        self.notificationCenter.addObserver(self,
                                            selector: #selector(didUpdateDownloadStatus(_:)),
                                            name: .didUpdateDownloadStatus, object: nil)
        self.notificationCenter.addObserver(self,
                                            selector: #selector(load(_:)),
                                            name: .didUpdateMyLibraryData,
                                            object: nil)
    }

    // MARK: Interactor

    func viewDidLoad() {
        presenter.setupView()
        load()
    }

    @objc private func load(_ notification: Notification? = nil) {
        worker.loadData(in: team) { [weak self] (initiated, items) in
            guard let strongSelf = self else { return }
            strongSelf.hasRemovableItem = false
            if strongSelf.items == nil {
                strongSelf.items = [MyLibraryCellViewModel]()
                strongSelf.presenter.presentData()
            }
            strongSelf.items?.removeAll()
            if !initiated || items.count == 0 {
                strongSelf.presenter.presentData()
                strongSelf.showEmptyAlert()
            } else {
                strongSelf.infoViewModel = nil
                strongSelf.items?.append(contentsOf: items.compactMap {
                    strongSelf.viewModelConverter.viewModel(from: $0, team: strongSelf.team,
                                                            downloadStatus: strongSelf.worker.downloadStatus(for: $0))
                })
                strongSelf.items = strongSelf.removeDuplicates(from: strongSelf.items ?? [])
                strongSelf.hasRemovableItem = strongSelf.items?.filter({ $0.removable == true }).first != nil
                strongSelf.presenter.presentData()
            }
        }
    }

    private func removeDuplicates(from results: [MyLibraryCellViewModel]) -> [MyLibraryCellViewModel] {
        var tempResults = [MyLibraryCellViewModel]()
        for result in results {
            if tempResults.contains(obj: result) == false {
                tempResults.append(result)
            }
        }
        return tempResults
    }
}

// MARK: - Protocol MyLibraryUserStorageInteractorInterface

extension MyLibraryUserStorageInteractor: MyLibraryUserStorageInteractorInterface {

    var title: String {
        return isEditing ? worker.editingTitle : worker.title
    }

    var subtitle: String {
        return isEditing && teamId != nil ? worker.editingSubtitle : ""
    }

    var addTitle: String {
        return worker.addTitle
    }

    var showAddButton: Bool {
        return worker.showAddButton
    }

    var showEditButton: Bool {
        return !isEditing && hasRemovableItem
    }

    var canEdit: Bool {
        return showEditButton
    }

    var itemType: MyLibraryCategoryType {
        return worker.item.type
    }

    var teamId: Int? {
        return team?.remoteID == 0 ? nil : team?.remoteID
    }

    func didTapEdit(isEditing: Bool) {
        notificationCenter.post(name: .stopAudio, object: nil)
        self.isEditing = isEditing
        bottomButtons = editingButtons
        presenter.present()
    }

    func didTapPlayItem(at row: Int) {
        guard let items = self.items, row < items.count, items[row].cellType == .AUDIO else {
            return
        }
        let item = items[row]

        let media = MediaPlayerModel(title: item.title,
                                     subtitle: "",
                                     url: item.mediaURL,
                                     totalDuration: 0,
                                     progress: 0,
                                     currentTime: 0,
                                     mediaRemoteId: item.remoteId)
        notificationCenter.post(name: .playPauseAudio, object: media)
    }

    func didTapAddNote() {
        router.presentCreateNote(noteId: nil, in: team)
    }

    func handleSelectedItem(at index: Int) -> Bool {
        guard let items = self.items, items.count > index else {
            return true
        }
        var keepSelection = false
        let item = items[index]
        if isEditing {
            let itemSelected = checkItemForDeletion(item)
            presenter.present()
            keepSelection = itemSelected
        } else {
            openItemDetails(item)
        }
        return keepSelection
    }

    func getIdentifiersForCheckedItems() -> Set<String> {
        return identifiersForCheck
    }

    func clearCheckedItems() {
        identifiersForCheck.removeAll()
    }
}

// MARK: - Info view's button actions

extension MyLibraryUserStorageInteractor {
    @objc private func cancelEditingTapped() {
        isEditing = false
        bottomButtons = nil
        clearCheckedItems()
        presenter.present()
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
        worker.deleteFor(identifiers: Array(identifiersForCheck)) { [weak self] (update, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.successfullyDeleted(identifier: update)
            }
            strongSelf.notificationCenter.post(name: .didUpdateMyLibraryData, object: nil)
        }
        cancelEditingTapped()
        presenter.present()
    }

    @objc private func cancelCellularDownload() {
        itemForDownload = nil
    }

    @objc private func continueCellularDownload() {
        if let item = itemForDownload {
            resumeDownload(for: item)
        }
        itemForDownload = nil
    }
}

// MARK: - Private methods

extension MyLibraryUserStorageInteractor {

    private func showEmptyAlert() {
        infoViewModel = MyLibraryUserStorageInfoViewModel(
            isFullscreen: false,
            icon: self.worker.emptyContentIcon,
            title: self.worker.emtptyContentAlertTitle,
            message: self.worker.emtptyContentAlertMessage)
        presenter.present()
    }

    private func checkItemForDeletion(_ item: MyLibraryCellViewModel) -> Bool {
        guard item.removable else { return false }
        let previouslySelected = identifiersForCheck.contains(item.identifier)
        if !previouslySelected {
            identifiersForCheck.insert(item.identifier)
        } else {
            identifiersForCheck.remove(item.identifier)
        }
        bottomButtons = editingButtons
        return identifiersForCheck.contains(item.identifier)
    }

    private func successfullyDeleted(identifier: String) {
        guard let items = self.items, let index = items.firstIndex(where: { $0.identifier == identifier }) else {
            return
        }
        self.items?.remove(at: index)
        presenter.deleteRow(at: index)
        if items.isEmpty {
            showEmptyAlert()
        }
    }

    private func openItemDetails(_ item: MyLibraryCellViewModel) {
        if handleContentType(for: item) {
            return
        }
        if handleMedia(for: item) {
            return
        }
    }

    private func handleContentType(for item: MyLibraryCellViewModel) -> Bool {
        switch item.type {
        case .EXTERNAL_LINK:
            guard let url = item.mediaURL else {
                log("Missing URL for bookmarked EXTERNAL_LINK", level: .error)
                return false
            }
            router.presentExternalUrl(url)
            return true
        case .NOTE:
            router.presentCreateNote(noteId: item.identifier, in: team)
            return true
        case .DOWNLOAD:
            return handleDownload(item: item)
        case .BOOKMARK, .UNKOWN:
            return false
        }
    }

    private func handleMedia(for item: MyLibraryCellViewModel) -> Bool {
        switch item.cellType {
        case .ARTICLE:
            router.presentContent(item.remoteId)
        case .VIDEO:
            guard let url = item.mediaURL else {
                assertionFailure("Cannot play video; missing URL")
                return false
            }
            ContentService.main.getContentItemById(item.remoteId) { [weak self] (item) in
                self?.router.presentVideo(url: url, item: item)
            }

        case .AUDIO:
            guard let items = self.items, let index = items.firstIndex(of: item) else {
                return false
            }
            didTapPlayItem(at: index)
        case .DOWNLOAD, .NOTE:
            log("Not a valid media type", level: .warning)
            return false
        }
        return true
    }

    private func handleDownload(item: MyLibraryCellViewModel) -> Bool {
        switch item.downloadStatus {
        case .downloading:
            itemForDownload = item
            downloadingCellTapped()
        case .waiting, .none:
            tryResumingDownload(for: item)
        case .downloaded:
            return false
        }
        return true
    }

    private func downloadingCellTapped() {
        presenter.presentAlert(title: worker.cancelDownloadItemsAlertTitle,
                               message: worker.cancelDownloadItemsAlertMessage,
                               buttons: cancelDownloadButtons)
    }

    @objc private func cancelCancelingDownloadTapped() {
        // nop
    }

    @objc private func continueCancelingDownloadTapped() {
        guard let item = itemForDownload else { return }
        pauseDownload(for: item)
        itemForDownload = nil
    }
}

// MARK: - Download management

extension MyLibraryUserStorageInteractor {
    private func pauseDownload(for item: MyLibraryCellViewModel) {
        worker.pauseDownload(for: item.identifier) { [weak self] (_) in
            self?.load()
        }
    }

    private func tryResumingDownload(for item: MyLibraryCellViewModel) {
        switch worker.reachabilityStatus {
        case .ethernetOrWiFi:
            resumeDownload(for: item)
        case .wwan:
            showMobileDataAlert(with: item)
        case .notReachable:
            showNoInternetAlert()
        }
    }

    private func showMobileDataAlert(with item: MyLibraryCellViewModel) {
        itemForDownload = item
        presenter.presentAlert(title: worker.cellullarDownloadTitle,
                               message: worker.cellullarDownloadMessage,
                               buttons: cellularDownloadButtons)
    }

    private func showNoInternetAlert() {
        presenter.presentNoInternetAlert()
    }

    private func resumeDownload(for item: MyLibraryCellViewModel) {
        worker.resumeDownload(for: item.identifier) { [weak self] (_) in
            self?.load()
        }
    }

    @objc private func didUpdateDownloadStatus(_ notification: Notification) {
        guard let items = self.items, let map = notification.object as? [String: QDMDownloadStatus] else {
            return
        }
        // Find map IDs which have a status DOWNLOADED and are also present in the items being displayed
        // swiftlint:disable reduce_boolean
        let itemIdentifiers = items.compactMap { $0.identifier }
        let downloadedItemIsInItems = map.keys.filter { itemIdentifiers.contains(obj: $0) }.reduce(false) {
            guard let item = map[$1] else { return $0 }
            return ($0 || item.status == .DOWNLOADED)
        }
        // swiftlint:enable reduce_boolean
        if downloadedItemIsInItems {
            load()
        }
    }
}
