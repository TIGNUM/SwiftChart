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
    private var bookmark: QDMUserStorage?
    private var download: QDMUserStorage?
    var downloadStatus: QOTDownloadStatus = .NONE

    weak var delegate: StreamVideoWorkerDelegate?

    private let service = UserStorageService.main
    private let reachability = QOTReachability()

    init(content: QDMContentItem?) {
        self.content = content

        bookmark = content?.userStorages?.filter { $0.userStorageType == .BOOKMARK }.first
        download = downloadItem(for: content)
        downloadStatus = downloadStatus(for: download)
    }

    var isLoggedIn: Bool {
        return qot_dal.SessionService.main.getCurrentSession() != nil
    }

    var reachabilityStatus: ReachabilityStatus {
        return reachability.status
    }

    lazy var downloadButtonTitle: String = {
        return AppTextService.get(AppTextKey.video_view_button_download)
    }()

    lazy var downloadingButtonTitle: String = {
        return AppTextService.get(AppTextKey.video_view_button_downloading)
    }()

    lazy var downloadedButtonTitle: String = {
        return AppTextService.get(AppTextKey.video_view_button_downloaded)
    }()

    lazy var noWifiTitle: String = {
        return AppTextService.get(AppTextKey.video_alert_title_use_mobile_data)
    }()

    lazy var noWifiMessage: String = {
        return AppTextService.get(AppTextKey.video_alert_body_use_mobile_data)
    }()

    lazy var cancelButtonTitle: String  = {
        return AppTextService.get(AppTextKey.generic_view_button_cancel)
    }()

    lazy var yesContinueButtonTitle: String = {
        return AppTextService.get(AppTextKey.video_alert_button_continue)
    }()

    lazy var contentItemId: Int? = {
        return content?.remoteID
    }()
}

extension StreamVideoWorker {
    var isBookmarked: Bool {
        return bookmark != nil
    }

    func toggleBookmark(_ completion: @escaping () -> Void) {
        if let bookmark = bookmark {
            // remove
            service.deleteUserStorage(bookmark) { [weak self] (error) in
                self?.bookmark = nil
                completion()
            }
        } else if let content = self.content {
            // add
            service.addBookmarkContentItem(content) { [weak self] (bookmark, error) in
                self?.bookmark = bookmark
                completion()
            }
        } else {
            bookmark = nil
            completion()
        }
    }

    func downloadItem(_ completion: @escaping (_ status: QOTDownloadStatus) -> Void) {
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
