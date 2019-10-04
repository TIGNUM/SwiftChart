//
//  MyLibraryUserStorageWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryUserStorageWorker {
    private let service = UserStorageService.main
    private var storages = [QDMUserStorage]()
    private let item: MyLibraryCategoryListModel
    private let reachability = QOTReachability()

    init(item: MyLibraryCategoryListModel) {
        self.item = item
    }

    // FIXME: Translate strings
    // MARK: Texts
    lazy var title: String = {
        switch item.type {
        case .ALL: return R.string.localized.myLibraryItemsTitleAll()
        case .BOOKMARKS: return R.string.localized.myLibraryItemsTitleBookmarks()
        case .DOWNLOADS: return R.string.localized.myLibraryItemsTitleDownloads()
        case .LINKS: return R.string.localized.myLibraryItemsTitleLinks()
        case .NOTES: return R.string.localized.myLibraryItemsTitleNotes()
        }
    }()

    lazy var addTitle: String = {
        return R.string.localized.myLibraryItemsButtonAdd()
    }()

    lazy var editingTitle: String = {
        switch item.type {
        case .ALL:
            return R.string.localized.myLibraryItemsEditTitleAll()
        case .BOOKMARKS:
            return R.string.localized.myLibraryItemsEditTitleBookmarks()
        case .DOWNLOADS:
            return R.string.localized.myLibraryItemsEditTitleDownloads()
        case .LINKS:
            return R.string.localized.myLibraryItemsEditTitleLinks()
        case .NOTES:
            return R.string.localized.myLibraryItemsEditTitleNotes()
        }
    }()

    lazy var cancelTitle: String = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
    }()

    lazy var removeTitle: String = {
        return R.string.localized.buttonTitleRemove()
    }()

    lazy var continueTitle: String = {
        return R.string.localized.alertButtonTitleContinue()
    }()

    lazy var showAddButton: Bool = {
        return item.type == .NOTES
    }()

    lazy var removeItemsAlertTitle: String = {
        return R.string.localized.myLibraryItemsAlertRemoveTitle()
    }()

    lazy var removeItemsAlertMessage: String = {
        return R.string.localized.myLibraryItemsAlertRemoveMessage()
    }()

    lazy var cellullarDownloadTitle: String = {
        return R.string.localized.alertTitleUseMobileData()
    }()

    lazy var cellullarDownloadMessage: String = {
        return R.string.localized.alertMessageUseMobileData()
    }()

    lazy var tapToDownload: String = {
        return R.string.localized.myLibraryItemsTapToDownload()
    }()

    lazy var emtptyContentAlertTitle: String = {
        switch item.type {
        case .ALL:
            return R.string.localized.myLibraryItemsAlertEmptyTitleAll()
        case .BOOKMARKS:
            return R.string.localized.myLibraryItemsAlertEmptyTitleBookmarks()
        case .DOWNLOADS:
            return R.string.localized.myLibraryItemsAlertEmptyTitleDownloads()
        case .LINKS:
            return R.string.localized.myLibraryItemsAlertEmptyTitleLinks()
        case .NOTES:
            return R.string.localized.myLibraryItemsAlertEmptyTitleNotes()
        }
    }()

    lazy var contentIcon: UIImage = {
        let image: UIImage?
        switch item.type {
        case .ALL:
            image = R.image.my_library_group()
        case .BOOKMARKS:
            image = R.image.my_library_bookmark()
        case .DOWNLOADS:
            image = R.image.my_library_download()
        case .LINKS:
            image = R.image.my_library_link()
        case .NOTES:
            image = R.image.my_library_note_light()
        }
        return image ?? UIImage()
    }()

    lazy var emtptyContentAlertMessage: NSAttributedString = {
        var text: String
        var icon: UIImage? = contentIcon
        switch item.type {
        case .ALL:
            text = R.string.localized.myLibraryItemsAlertEmptyMessageAll()
            icon = nil
        case .BOOKMARKS:
            text = R.string.localized.myLibraryItemsAlertEmptyMessageBookmarks()
        case .DOWNLOADS:
            text = R.string.localized.myLibraryItemsAlertEmptyMessageDownloads()
        case .LINKS:
            text = R.string.localized.myLibraryItemsAlertEmptyMessageLinks()
        case .NOTES:
            text = R.string.localized.myLibraryItemsAlertEmptyMessageNotes()
            icon = nil
        }

        let searchText = "{icon}"
        let attributedText = NSMutableAttributedString(string: text)
        guard let range = text.range(of: searchText) else {
            return attributedText
        }

        let replacementText: NSAttributedString
        if let icon = icon {
            let attachment = NSTextAttachment()
            attachment.image = icon
            replacementText = NSAttributedString(attachment: attachment)
        } else {
            replacementText = NSAttributedString(string: addTitle,
                                                 attributes: [.font: UIFont.sfProtextSemibold(ofSize: 16),
                                                              .foregroundColor: UIColor.accent])
        }
        let nsRange = NSRange(range, in: text)
        attributedText.deleteCharacters(in: nsRange)
        attributedText.insert(replacementText, at: nsRange.location)

        return attributedText
    }()

    lazy var personalNote: String = {
        return R.string.localized.myLibraryItemsPersonalNote()
    }()

    lazy var downloading: String = {
        return R.string.localized.myLibraryItemsDownloading()
    }()

    lazy var waitingForDownload: String = {
        return R.string.localized.myLibraryItemsWaitingDownload()
    }()

    lazy var read: String = {
        return R.string.localized.myLibraryItemsToRead()
    }()

    lazy var watch: String = {
        return R.string.localized.myLibraryItemsToWatch()
    }()

    lazy var listen: String = {
        return R.string.localized.myLibraryItemsToListen()
    }()

    lazy var contentType: MyLibraryUserStorageContentType = {
        switch item.type {
        case .ALL: return .all
        case .BOOKMARKS: return .bookmarks
        case .DOWNLOADS: return .downloads
        case .LINKS: return .links
        case .NOTES: return .notes
        }
    }()
}

// MARK: Data loading
extension MyLibraryUserStorageWorker {

    func loadData(_ completion: @escaping (_ initiated: Bool, _ items: [QDMUserStorage]) -> Void) {
        var storageType: UserStorageType = .UNKOWN
        switch item.type {
        case .BOOKMARKS: storageType = .BOOKMARK
        case .DOWNLOADS: storageType = .DOWNLOAD
        case .LINKS: storageType = .EXTERNAL_LINK
        case .NOTES: storageType = .NOTE
        case .ALL: storageType = .UNKOWN
        }
        if item.type != .ALL {
            service.getUserStorages(for: storageType) { [weak self] (storages, initiated, error) in
                self?.handleStorages(storages, initiated: initiated, completion: completion)
            }
        } else {
            service.getUserStorages { [weak self] (storages, initiated, error) in
                self?.handleStorages(storages, initiated: initiated, completion: completion)
            }
        }
    }

    func downloadStatus(for item: QDMUserStorage) -> QDMDownloadStatus {
        return service.downloadStatus(for: item)
    }

    func pauseDownload(for itemId: String, completion: @escaping (_ status: QOTDownloadStatus) -> Void) {
        guard let item = storages.first(where: { $0.qotId == itemId }) else {
            completion(.NONE)
            return
        }
        service.deleteUserStorage(item) { (error) in
            completion(.NONE)
        }
    }

    func resumeDownload(for itemId: String, completion: @escaping (_ status: QOTDownloadStatus) -> Void) {
        guard let item = storages.first(where: { $0.qotId == itemId }) else {
            completion(.NONE)
            return
        }
        service.resumeDownload(item, completion: completion)
    }

    var reachabilityStatus: ReachabilityStatus {
        return reachability.status
    }
}

// MARK: Private methods
extension MyLibraryUserStorageWorker {
    private func handleStorages(_ storages: [QDMUserStorage]?,
                        initiated: Bool,
                        completion: @escaping (_ initiated: Bool, _ items: [QDMUserStorage]) -> Void) {
        let unsortedStorages: [QDMUserStorage] = storages ?? []
        self.storages = unsortedStorages.sorted(by: {
            ($0.createdAt?.timeIntervalSinceReferenceDate ?? 0) > ($1.createdAt?.timeIntervalSinceReferenceDate ?? 0) })
        completion(initiated, self.storages)
    }

    func deleteFor(identifiers: [String], _ update: ((_ identifier: String, _ error: Error?) -> Void)?) {
        let storagesToDelete = self.storages.compactMap { (storage) -> QDMUserStorage? in
            identifiers.contains(storage.qotId ?? "INVALID_IDENTIFIER") ? storage : nil
        }
        for storage in storagesToDelete {
            guard let identifier = storage.qotId else {
                break
            }
            service.deleteUserStorage(storage) { (error) in
                update?(identifier, error)
            }
        }
    }
}
