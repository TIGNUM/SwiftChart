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
    let item: MyLibraryCategoryListModel

    init(item: MyLibraryCategoryListModel) {
        self.item = item
    }

    // FIXME: Translate strings
    // MARK: Texts
    lazy var title: String = {
        switch item.type {
        case .ALL: return AppTextService.get(.my_qot_my_library_all_section_header_title)
        case .BOOKMARK: return AppTextService.get(.my_qot_my_library_bookmarks_section_header_title)
        case .DOWNLOAD: return AppTextService.get(.my_qot_my_library_downloads_section_header_title)
        case .EXTERNAL_LINK: return AppTextService.get(.my_qot_my_library_links_section_header_title)
        case .NOTE: return AppTextService.get(.my_qot_my_library_notes_section_header_title)
        }
    }()

    lazy var addTitle: String = {
        return AppTextService.get(.my_qot_my_library_notes_section_header_button_add)
    }()

    lazy var editingTitle: String = {
        switch item.type {
        case .NOTE:
            return AppTextService.get(.my_qot_my_library_notes_edit_title)
        default:
            return AppTextService.get(.my_x_my_library_remove_items_title)
        }
    }()

    lazy var editingSubtitle: String = {
           return AppTextService.get(.my_x_my_library_remove_items_subtitle)
       }()

    lazy var cancelTitle: String = {
        return AppTextService.get(.generic_view_button_cancel)
    }()

    lazy var removeTitle: String = {
        return AppTextService.get(.generic_view_button_delete)
    }()

    lazy var continueTitle: String = {
        return AppTextService.get(.my_qot_my_library_alert_delete_button_continue)
    }()

    lazy var showAddButton: Bool = {
        return item.type == .NOTE
    }()

    lazy var cancelDownloadItemsAlertTitle: String = {
        return AppTextService.get(.my_qot_my_library_downloads_alert_cancel_download_title)
    }()

    lazy var cancelDownloadItemsAlertMessage: String = {
        return AppTextService.get(.my_qot_my_library_downloads_alert_cancel_download_body)
    }()

    lazy var removeItemsAlertTitle: String = {
        return AppTextService.get(.my_qot_my_library_alert_delete_title)
    }()

    lazy var removeItemsAlertMessage: String = {
        return AppTextService.get(.my_qot_my_library_alert_delete_body)
    }()

    lazy var cellullarDownloadTitle: String = {
        return AppTextService.get(.my_qot_my_library_downloads_alert_use_mobile_data_title)
    }()

    lazy var cellullarDownloadMessage: String = {
        return AppTextService.get(.my_qot_my_library_downloads_alert_use_mobile_data_body)
    }()

    lazy var emtptyContentAlertTitle: String = {
        switch item.type {
        case .ALL:
            return AppTextService.get(.my_qot_my_library_all_section_header_title)
        case .BOOKMARK:
            return AppTextService.get(.my_qot_my_library_bookmarks_section_header_title)
        case .DOWNLOAD:
            return AppTextService.get(.my_qot_my_library_downloads_section_header_title)
        case .EXTERNAL_LINK:
            return AppTextService.get(.my_qot_my_library_links_section_header_title)
        case .NOTE:
            return AppTextService.get(.my_qot_my_library_notes_null_state_subtitle)
        }
    }()

    lazy var emptyContentIcon: UIImage = {
        let image: UIImage?
        switch item.type {
        case .ALL:
            image = R.image.my_library_group()
        case .BOOKMARK:
            image = R.image.my_library_bookmark()
        case .DOWNLOAD:
            image = R.image.my_library_download()
        case .EXTERNAL_LINK:
            image = R.image.my_library_link()
        case .NOTE:
            image = R.image.my_library_note_light()
        }
        return image ?? UIImage()
    }()

    lazy var textIcon: UIImage = {
        let image: UIImage?
        switch item.type {
        case .ALL:
            image = R.image.my_library_group()
        case .BOOKMARK:
            image = R.image.my_library_bookmark_text_icon()
        case .DOWNLOAD:
            image = R.image.my_library_download_text_icon()
        case .EXTERNAL_LINK:
            image = R.image.my_library_link_text_icon()
        case .NOTE:
            image = R.image.my_library_note_light()
        }
        return image ?? UIImage()
    }()

    lazy var emtptyContentAlertMessage: NSAttributedString = {
        var text: String
        var icon: UIImage? = textIcon
        switch item.type {
        case .ALL:
            text = AppTextService.get(.my_qot_my_library_all_null_state_body)
            icon = nil
        case .BOOKMARK:
            text = AppTextService.get(.my_qot_my_library_bookmarks_null_state_body)
        case .DOWNLOAD:
            text = AppTextService.get(.my_qot_my_library_downloads_null_state_body)
        case .EXTERNAL_LINK:
            text = AppTextService.get(.my_qot_my_library_links_null_state_body)
        case .NOTE:
            text = AppTextService.get(.my_qot_my_library_notes_null_state_title)
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

    lazy var contentType: MyLibraryUserStorageContentType = {
        switch item.type {
        case .ALL: return .all
        case .BOOKMARK: return .bookmarks
        case .DOWNLOAD: return .downloads
        case .EXTERNAL_LINK: return .links
        case .NOTE: return .notes
        }
    }()

    func markAsRead(teamNewsFeeds: [QDMTeamNewsFeed]?, _ completion: @escaping () -> Void) {
        guard let feeds = teamNewsFeeds else {
            DispatchQueue.main.async { completion() }
            return
        }
        TeamService.main.markAsRead(newsFeeds: feeds) { (_) in
            completion()
        }
    }
}

// MARK: Data loading
extension MyLibraryUserStorageWorker {

    func loadData(in team: QDMTeam?,
                  _ completion: @escaping (_ initiated: Bool, [QDMUserStorage], [QDMTeamNewsFeed]?) -> Void) {
        var storageType: UserStorageType = .UNKOWN
        switch item.type {
        case .BOOKMARK: storageType = .BOOKMARK
        case .DOWNLOAD: storageType = .DOWNLOAD
        case .EXTERNAL_LINK: storageType = .EXTERNAL_LINK
        case .NOTE: storageType = .NOTE
        case .ALL: storageType = .UNKOWN
        }

        if item.type != .ALL {
            if let team = team {
                let teamService = TeamService.main
                service.getTeamStorages(for: storageType, in: team) { [weak self] (storages, initiated, error) in
                    self?.handleStorages(storages)
                    teamService.teamNewsFeeds(for: team, type: .STORAGE_ADDED, onlyUnread: true) { (feeds, _, _) in
                        completion(initiated, self?.storages ?? [], feeds)
                    }
                }
            } else {
                service.getUserStorages(for: storageType) { [weak self] (storages, initiated, error) in
                    self?.handleStorages(storages)
                    completion(initiated, self?.storages ?? [], nil)
                }
            }
        } else {
            if let team = team {
                let teamService = TeamService.main
                service.getTeamStorages(in: team) { [weak self] (teamStorages, initiated, error) in
                    self?.handleStorages(teamStorages)
                    teamService.teamNewsFeeds(for: team, type: .STORAGE_ADDED, onlyUnread: true) { (feeds, _, _) in
                        completion(initiated, self?.storages ?? [], feeds)
                    }
                }
            } else {
                service.getUserStorages { [weak self] (storages, initiated, error) in
                    self?.handleStorages(storages)
                    completion(initiated, self?.storages ?? [], nil)
                }
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
        return QOTReachability().status
    }
}

// MARK: Private methods
extension MyLibraryUserStorageWorker {
    private func handleStorages(_ storages: [QDMUserStorage]?) {
        let unsortedStorages: [QDMUserStorage] = storages ?? []
        self.storages = unsortedStorages.sorted(by: {
            ($0.createdAt?.timeIntervalSinceReferenceDate ?? 0) > ($1.createdAt?.timeIntervalSinceReferenceDate ?? 0) })
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
