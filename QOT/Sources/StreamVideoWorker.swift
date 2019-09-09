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
        download = content?.userStorages?.filter { $0.userStorageType == .DOWNLOAD }.first

        if let status = download?.downloadStaus {
            switch status {
            case .NONE: downloadStatus = .NONE
            case .WAITING: downloadStatus = .WAITING
            case .DOWNLOADING: downloadStatus = .DOWNLOADING
            case .DONE: downloadStatus = .DOWNLOADED
            }
        }
    }

    var isLoggedIn: Bool {
        return qot_dal.SessionService.main.getCurrentSession() != nil
    }

    var isConnectedToWiFi: Bool {
        return reachability.isReachableOnEthernetOrWiFi
    }

    lazy var downloadButtonTitle: String = {
        return R.string.localized.videoFullScreenButtonDownload()
    }()

    lazy var downloadingButtonTitle: String = {
        return R.string.localized.videoFullScreenButtonDownloading()
    }()

    lazy var downloadedButtonTitle: String = {
        return R.string.localized.videoFullScreenButtonDownloaded()
    }()

    lazy var noWifiTitle: String = {
        return R.string.localized.alertTitleUseMobileData()
    }()

    lazy var noWifiMessage: String = {
        return R.string.localized.alertMessageUseMobileData()
    }()

    lazy var cancelButtonTitle: String  = {
        return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
    }()

    lazy var yesContinueButtonTitle: String = {
        return R.string.localized.buttonTitleYesContinue()
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
            service.deleteUserStorage(bookmark) { (error) in
                self.bookmark = nil
                completion()
            }
        } else if let content = self.content {
            // add
            service.addBookmarkContentItem(content) { (bookmark, error) in
                self.bookmark = bookmark
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
}
