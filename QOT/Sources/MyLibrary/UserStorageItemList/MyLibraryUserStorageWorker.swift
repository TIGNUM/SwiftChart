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
        case .ALL: return AppTextService.get(AppTextKey.my_qot_my_library_all_view_title)
        case .BOOKMARKS: return AppTextService.get(AppTextKey.my_qot_my_library_bookmarks_view_title)
        case .DOWNLOADS: return AppTextService.get(AppTextKey.my_qot_my_library_downloads_view_title)
        case .LINKS: return AppTextService.get(AppTextKey.my_qot_my_library_links_view_title)
        case .NOTES: return AppTextService.get(AppTextKey.my_qot_my_library_notes_view_title)
        }
    }()

    lazy var addTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_view_button_add)
    }()

    lazy var editingTitle: String = {
        switch item.type {
        case .ALL:
            return AppTextService.get(AppTextKey.my_qot_my_library_all_edit_title)
        case .BOOKMARKS:
            return AppTextService.get(AppTextKey.my_qot_my_library_bookmarks_edit_title)
        case .DOWNLOADS:
            return AppTextService.get(AppTextKey.my_qot_my_library_downloads_edit_title)
        case .LINKS:
            return AppTextService.get(AppTextKey.my_qot_my_library_links_edit_title)
        case .NOTES:
            return AppTextService.get(AppTextKey.my_qot_my_library_notes_edit_title)
        }
    }()

    lazy var cancelTitle: String = {
        return AppTextService.get(AppTextKey.generic_view_button_cancel)
    }()

    lazy var removeTitle: String = {
        return AppTextService.get(AppTextKey.generic_view_button_delete)
    }()

    lazy var continueTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_alert_button_continue)
    }()

    lazy var showAddButton: Bool = {
        return item.type == .NOTES
    }()

    lazy var cancelDownloadItemsAlertTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_alert_title_cancel_download)
    }()

    lazy var cancelDownloadItemsAlertMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_alert_body_cancel_download)
    }()

    lazy var removeItemsAlertTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_items_alert_title_delete)
    }()

    lazy var removeItemsAlertMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_items_alert_body_delete)
    }()

    lazy var cellullarDownloadTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_alert_title_use_mobile_data)
    }()

    lazy var cellullarDownloadMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_alert_body_use_mobile_data)
    }()

    lazy var tapToDownload: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_items_view_button_download)
    }()

    lazy var emtptyContentAlertTitle: String = {
        switch item.type {
        case .ALL:
            return AppTextService.get(AppTextKey.my_qot_my_library_all_view_title)
        case .BOOKMARKS:
            return AppTextService.get(AppTextKey.my_qot_my_library_bookmarks_view_title)
        case .DOWNLOADS:
            return AppTextService.get(AppTextKey.my_qot_my_library_downloads_view_title)
        case .LINKS:
            return AppTextService.get(AppTextKey.my_qot_my_library_links_view_title)
        case .NOTES:
            return AppTextService.get(AppTextKey.my_qot_my_library_notes_view_title_your_notes)
        }
    }()

    lazy var emptyContentIcon: UIImage = {
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

    lazy var textIcon: UIImage = {
        let image: UIImage?
        switch item.type {
        case .ALL:
            image = R.image.my_library_group()
        case .BOOKMARKS:
            image = R.image.my_library_bookmark_text_icon()
        case .DOWNLOADS:
            image = R.image.my_library_download_text_icon()
        case .LINKS:
            image = R.image.my_library_link_text_icon()
        case .NOTES:
            image = R.image.my_library_note_light()
        }
        return image ?? UIImage()
    }()

    lazy var emtptyContentAlertMessage: NSAttributedString = {
        var text: String
        var icon: UIImage? = textIcon
        switch item.type {
        case .ALL:
            text = AppTextService.get(AppTextKey.my_qot_my_library_all_view_subtitle)
            icon = nil
        case .BOOKMARKS:
            text = AppTextService.get(AppTextKey.my_qot_my_library_bookmarks_view_subtitle)
        case .DOWNLOADS:
            text = AppTextService.get(AppTextKey.my_qot_my_library_downloads_view_subtitle)
        case .LINKS:
            text = AppTextService.get(AppTextKey.my_qot_my_library_links_view_subtitle)
        case .NOTES:
            text = AppTextService.get(AppTextKey.my_qot_my_library_notes_alert_subtitle)
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
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_view_subtitle2)
    }()

    lazy var downloading: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_media_download_view_title_downloading)
    }()

    lazy var waitingForDownload: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_media_download_view_title_waiting)
    }()

    lazy var read: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_items_view_title_read)
    }()

    lazy var watch: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_items_view_title_watch)
    }()

    lazy var listen: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_items_view_title_listen)
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
