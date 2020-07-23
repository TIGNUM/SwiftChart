//
//  StreamVideoWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 26/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol StreamVideoWorkerDelegate: class {
    func didUpdateData()
}

final class StreamVideoWorker {

    private var content: QDMContentItem?
    private var bookmarks = [QDMUserStorage]()
    private var download: QDMUserStorage?
    var bookMarkedToggled: Bool = false
    var downloadStatus: QOTDownloadStatus = .NONE
    var wasBookmarkedOnce: Bool = false

    weak var delegate: StreamVideoWorkerDelegate?

    private let service = UserStorageService.main

    init(content: QDMContentItem?) {
        self.content = content

        bookmarks = content?.userStorages?.filter { $0.userStorageType == .BOOKMARK } ?? []
        download = downloadItem(for: content)
        downloadStatus = downloadStatus(for: download)
        wasBookmarkedOnce = false
    }

    var isLoggedIn: Bool {
        return SessionService.main.getCurrentSession() != nil
    }

    var reachabilityStatus: ReachabilityStatus {
        return QOTReachability().status
    }

    lazy var downloadButtonTitle: String = {
        return AppTextService.get(.generic_download_status_video_button_download)
    }()

    lazy var downloadingButtonTitle: String = {
        return AppTextService.get(.generic_download_status_video_button_downloading)
    }()

    lazy var downloadedButtonTitle: String = {
        return AppTextService.get(.generic_download_status_video_button_downloaded)
    }()

    lazy var noWifiTitle: String = {
        return AppTextService.get(.generic_content_video_alert_use_mobile_data_title_use_mobile_data)
    }()

    lazy var noWifiMessage: String = {
        return AppTextService.get(.generic_content_video_alert_use_mobile_data_body_use_mobile_data)
    }()

    lazy var cancelButtonTitle: String  = {
        return AppTextService.get(.generic_view_button_cancel)
    }()

    lazy var yesContinueButtonTitle: String = {
        return AppTextService.get(.generic_content_video_alert_use_mobile_data_button_continue)
    }()

    lazy var contentItemId: Int? = {
        return content?.remoteID
    }()

    lazy var contentFormat: ContentFormat? = {
        return content?.format
    }()

    func updateBookmarks(_ completion: @escaping () -> Void) {
        ContentService.main.getContentItemById(content?.remoteID ?? 0) { [weak self] (item) in
            self?.bookmarks = item?.userStorages?.filter { $0.userStorageType == .BOOKMARK } ?? []
            completion()
        }
    }
}

extension StreamVideoWorker {
    var isBookmarked: Bool {
        return bookmarks.isEmpty == false
    }

    func toggleBookmark(_ completion: @escaping () -> Void) {
        bookMarkedToggled = true
        if let bookmark = bookmarks.filter({ $0.teamQotId == nil }).first {
            // remove
            service.deleteUserStorage(bookmark) { [weak self] (error) in
                self?.bookmarks.remove(object: bookmark)
                self?.updateBookmarks(completion)
            }
        } else if let content = self.content {
            // add
            service.addBookmarkContentItem(content) { [weak self] (bookmark, error) in
                if let bookmark = bookmark {
                    self?.bookmarks.append(bookmark)
                }
                self?.updateBookmarks(completion)
            }
        } else {
            bookmarks.removeAll()
            updateBookmarks(completion)
        }
    }

    func downloadItem(_ completion: @escaping (_ status: QOTDownloadStatus) -> Void) {
        bookMarkedToggled = false
        guard let item = content else {
            downloadStatus = .NONE
            completion(.NONE)
            return
        }

        if let download = self.download {
            let downloadStatus = service.downloadStatus(for: download).status
            switch downloadStatus {
            case .NONE,
                 .WAITING: service.resumeDownload(download) { [weak self] (status) in
                    self?.downloadStatus = status
                    completion(status)
                }
            case .DOWNLOADING: service.deleteUserStorage(download) { [weak self] (_) in
                    self?.downloadStatus = .NONE
                    completion(.NONE)
                }
            case .DOWNLOADED:
                completion(.DOWNLOADED)
            }
        } else {
            service.addToDownload(contentItem: item) { [weak self] (storage, error) in
                self?.download = storage
                guard let download = storage else {
                    self?.downloadStatus = .NONE
                    completion(.NONE)
                    return
                }
                self?.service.resumeDownload(download) { [weak self] (status) in
                    self?.downloadStatus = status
                    completion(status)
                }
            }
        }
    }

    func updateItemDownloadStatus(_ completion: @escaping (() -> Void)) {
        guard let itemId = content?.remoteID else {
            return
        }
        ContentService.main.getContentItemById(itemId) { [weak self] (item) in
            guard let strongSelf = self else { return }
            strongSelf.content = item
            strongSelf.download = strongSelf.downloadItem(for: item)
            strongSelf.downloadStatus = strongSelf.downloadStatus(for: strongSelf.download)
            completion()
        }
    }
}

private extension StreamVideoWorker {

    func downloadItem(for item: QDMContentItem?) -> QDMUserStorage? {
        return item?.userStorages?.filter { $0.userStorageType == .DOWNLOAD }.first
    }

    func downloadStatus(for download: QDMUserStorage?) -> QOTDownloadStatus {
        guard let status = download?.downloadStaus else { return .NONE }
        switch status {
        case .NONE: return .NONE
        case .WAITING: return .WAITING
        case .DOWNLOADING: return .DOWNLOADING
        case .DONE: return .DOWNLOADED
        }
    }
}
