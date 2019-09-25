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
    private let notificationCenter: NotificationCenter

    private (set) var isEditing: Bool = false
    private (set) var infoViewModel: MyLibraryUserStorageInfoViewModel? = nil
    private (set) var bottomButtons: [ButtonParameters]? = nil

    var items = [MyLibraryCellViewModel]()
    private var identifiersForCheck = Set<String>()
    private var itemForDownload: MyLibraryCellViewModel?

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
    private lazy var cellularDownloadButtons: [UIBarButtonItem] = {
        return [RoundedButton(title: worker.cancelTitle, target: self, action: #selector(cancelCellularDownload)).barButton,
                RoundedButton(title: worker.continueTitle, target: self, action: #selector(continueCellularDownload)).barButton]
    }()

    // MARK: - Init

    init(worker: MyLibraryUserStorageWorker,
         presenter: MyLibraryUserStoragePresenterInterface,
         router: MyLibraryUserStorageRouterInterface,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.notificationCenter = notificationCenter

        self.notificationCenter.addObserver(self,
                                            selector: #selector(load(_:)),
                                            name: .UIApplicationDidBecomeActive, object: nil)
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
        worker.loadData { [weak self] (initiated, items) in
            guard let strongSelf = self else { return }
            strongSelf.items.removeAll()
            if !initiated || items.count == 0 {
                strongSelf.showEmptyAlert()
            } else {
                strongSelf.infoViewModel = nil
                strongSelf.items.append(contentsOf: items.compactMap { strongSelf.viewModel(from: $0) })
                strongSelf.presenter.presentData()
            }
        }
    }
}

// MARK: - Protocol MyLibraryUserStorageInteractorInterface

extension MyLibraryUserStorageInteractor: MyLibraryUserStorageInteractorInterface {

    var title: String {
        return isEditing ? worker.editingTitle : worker.title
    }

    var addTitle: String {
        return worker.addTitle
    }

    var showAddButton: Bool {
        return worker.showAddButton
    }

    var showEditButton: Bool {
        return !(isEditing || items.isEmpty || infoViewModel != nil) || worker.showAddButton
    }

    var canEdit: Bool {
        return !(isEditing || items.isEmpty)
    }

    var contentType: MyLibraryUserStorageContentType {
        return worker.contentType
    }

    func didTapEdit(isEditing: Bool) {
        notificationCenter.post(name: .stopAudio, object: nil)
        self.isEditing = isEditing
        bottomButtons = editingButtons
        presenter.present()
    }

    func didTapPlayItem(at row: Int) {
        guard row < items.count, items[row].cellType == .AUDIO else {
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
        router.presentCreateNote(noteId: nil)
    }

    func handleSelectedItem(at index: Int) -> Bool {
        guard items.count > index else {
            return false
        }

        let item = items[index]
        if isEditing {
            return checkItemForDeletion(item)
        } else {
            openItemDetails(item)
        }

        return true
    }
}

// MARK: - Info view's button actions

extension MyLibraryUserStorageInteractor {
    @objc private func cancelEditingTapped() {
        isEditing = false
        bottomButtons = nil
        identifiersForCheck.removeAll()
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
            icon: self.worker.contentIcon,
            title: self.worker.emtptyContentAlertTitle,
            message: self.worker.emtptyContentAlertMessage)
        presenter.present()
    }

    private func checkItemForDeletion(_ item: MyLibraryCellViewModel) -> Bool {
        let previouslySelected = identifiersForCheck.contains(item.identifier)
        if !previouslySelected {
            identifiersForCheck.insert(item.identifier)
        } else {
            identifiersForCheck.remove(item.identifier)
        }
        bottomButtons = editingButtons
        presenter.present()
        return !previouslySelected
    }

    private func successfullyDeleted(identifier: String) {
        guard let index = items.firstIndex(where: { $0.identifier == identifier }) else {
            return
        }
        items.remove(at: index)
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
                qot_dal.log("Missing URL for bookmarked EXTERNAL_LINK", level: .error)
                return false
            }
            router.presentExternalUrl(url)
            return true
        case .NOTE:
            router.presentCreateNote(noteId: item.identifier)
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
            router.presentArticle(id: item.remoteId)
        case .VIDEO:
            guard let url = item.mediaURL else {
                assertionFailure("Cannot play video; missing URL")
                return false
            }
            qot_dal.ContentService.main.getContentItemById(item.remoteId) { [weak self] (item) in
                self?.router.presentVideo(url: url, item: item)
            }

        case .AUDIO:
            guard let index = items.index(of: item) else {
                return false
            }
            didTapPlayItem(at: index)
        case .DOWNLOAD, .NOTE:
            qot_dal.log("Not a valid media type", level: .warning)
            return false
        }
        return true
    }

    private func handleDownload(item: MyLibraryCellViewModel) -> Bool {
        switch item.downloadStatus {
        case .downloading:
            pauseDownload(for: item)
        case .waiting, .none:
            tryResumingDownload(for: item)
        case .downloaded:
            return false
        }
        return true
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
        guard let map = notification.object as? [String: QDMDownloadStatus] else {
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

// MARK: - Cell presentation

extension MyLibraryUserStorageInteractor {
    private func viewModel(from item: QDMUserStorage) -> MyLibraryCellViewModel? {
        switch item.userStorageType {
        case .DOWNLOAD:
            return downloadViewModel(from: item)
        case .BOOKMARK:
            return bookmarkViewModel(from: item)
        case .NOTE:
            return noteViewModel(from: item)
        case .EXTERNAL_LINK:
            return linkViewModel(from: item)
        case .UNKOWN:
            return nil
        }
    }

    private func downloadViewModel(from item: QDMUserStorage) -> MyLibraryCellViewModel {
        let cellStatus: MyLibraryCellViewModel.DownloadStatus
        let description: String
        var fullDuration = ""
        let cellType: MyLibraryCellViewModel.CellType

        let downloadStatus = worker.downloadStatus(for: item)
        switch downloadStatus.status {
        case .NONE:
            cellType = .DOWNLOAD
            cellStatus = .waiting
            description = worker.tapToDownload
        case .WAITING:
            cellType = .DOWNLOAD
            cellStatus = .waiting
            description = worker.waitingForDownload
        case .DOWNLOADING:
            cellType = .DOWNLOAD
            cellStatus = .downloading
            description = worker.downloading
        case .DOWNLOADED:
            cellType = self.cellType(for: item)
            cellStatus = .downloaded
            let duration = mediaDuration(for: item)
            description = duration.simple
            fullDuration = duration.full
        }
        return MyLibraryCellViewModel(cellType: cellType,
                                      title: item.title ?? "",
                                      description: description,
                                      duration: fullDuration,
                                      icon: mediaIcon(for: item),
                                      previewURL: URL(string: item.previewImageUrl ?? ""),
                                      type: item.userStorageType,
                                      mediaType: item.mediaType ?? .UNKOWN,
                                      downloadStatus: cellStatus,
                                      identifier: item.qotId ?? "",
                                      remoteId: Int(item.contentId ?? "0") ?? 0,
                                      mediaURL: URL(string: item.mediaPath() ?? ""))
    }

    private func noteViewModel(from item: QDMUserStorage) -> MyLibraryCellViewModel {
        var descriptionExtension: String = ""
        if let date = item.createdAt {
            descriptionExtension = " | \(DateFormatter.ddMMM.string(from: date))"
        }
        let description = worker.personalNote + descriptionExtension
        return MyLibraryCellViewModel(cellType: .NOTE,
                                      title: item.note ?? "",
                                      description: description,
                                      duration: "",
                                      icon: R.image.my_library_note_light(),
                                      previewURL: nil,
                                      type: item.userStorageType,
                                      mediaType: item.mediaType ?? .UNKOWN,
                                      downloadStatus: .none,
                                      identifier: item.qotId ?? "",
                                      remoteId: Int(item.contentId ?? "0") ?? 0,
                                      mediaURL: URL(string: item.mediaPath() ?? ""))
    }

    private func linkViewModel(from item: QDMUserStorage) -> MyLibraryCellViewModel {
        var description: String = ""
        if let urllString = item.url, let url = URL(string: urllString), let host = url.host {
            description = host.replacingOccurrences(of: "www.", with: "")
        }
        return MyLibraryCellViewModel(cellType: .ARTICLE,
                                      title: item.title ?? "",
                                      description: description,
                                      duration: "",
                                      icon: R.image.my_library_link(),
                                      previewURL: URL(string: item.previewImageUrl ?? ""),
                                      type: item.userStorageType,
                                      mediaType: item.mediaType ?? .UNKOWN,
                                      downloadStatus: .none,
                                      identifier: item.qotId ?? "",
                                      remoteId: Int(item.contentId ?? "0") ?? 0,
                                      mediaURL: URL(string: item.mediaPath() ?? ""))
    }

    private func bookmarkViewModel(from item: QDMUserStorage) -> MyLibraryCellViewModel {
        let durations = mediaDuration(for: item)
        return MyLibraryCellViewModel(cellType: cellType(for: item),
                                      title: item.title ?? "",
                                      description: durations.simple,
                                      duration: durations.full,
                                      icon: mediaIcon(for: item),
                                      previewURL: URL(string: item.previewImageUrl ?? ""),
                                      type: item.userStorageType,
                                      mediaType: item.mediaType ?? .UNKOWN,
                                      downloadStatus: .none,
                                      identifier: item.qotId ?? "",
                                      remoteId: Int(item.contentId ?? "0") ?? 0,
                                      mediaURL: URL(string: item.mediaPath() ?? ""))
    }

    // MARK: Presentation helper methods
    private func mediaIcon(for item: QDMUserStorage) -> UIImage? {
        switch item.mediaType ?? .UNKOWN {
        case .VIDEO:
            return R.image.my_library_camera()
        case .AUDIO:
            return R.image.my_library_listen()
        case .PDF, .UNKOWN:
            return R.image.my_library_read()
        }
    }

    private func mediaDuration(for item: QDMUserStorage) -> (full: String, simple: String) {
        var durationMinute = (item.durationInSeconds ?? 0)/60
        let durationSeconds = (item.durationInSeconds ?? 0)%60
        let fullDuration = String(format: "%d:%02d", durationMinute, durationSeconds)

        var postfix = worker.read
        switch item.mediaType ?? .UNKOWN {
        case .VIDEO:
            postfix = worker.watch
        case .AUDIO:
            postfix = worker.listen
        default:
            break
        }
        var simpleDuration = ""
        if durationSeconds > 30 {
            durationMinute += 1
        }
        if  durationMinute > 0 {
            simpleDuration = "\(durationMinute) min \(postfix)"
        } else if durationSeconds > 0 {
            simpleDuration = fullDuration
        }
        if item.title == "Performance mindset" {
            print("something")
        }
        return (fullDuration, simpleDuration)
    }

    private func cellType(for item: QDMUserStorage) -> MyLibraryCellViewModel.CellType {
        let cellType: MyLibraryCellViewModel.CellType
        switch item.contentType {
        case .CONTENT_ITEM:
            switch item.mediaType ?? .UNKOWN {
            case .VIDEO:
                cellType = .VIDEO
            case .AUDIO:
                cellType = .AUDIO
            default:
                cellType = .ARTICLE
            }
        default:
            cellType = .ARTICLE
        }
        return cellType
    }
}
