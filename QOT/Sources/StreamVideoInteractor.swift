//
//  StreamVideoInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 26/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol StreamVideoInteractorDelegate: class {
    func didUpdateData(interactor: StreamVideoInteractorInterface)
    func askUserToDownloadWithoutWiFi(interactor: StreamVideoInteractorInterface)
    func showNoInternetConnectionAlert(interactor: StreamVideoInteractorInterface)
}

protocol StreamVideoInteractorInterface {
    var downloadButtonTitle: String { get }
    var noWifiTitle: String { get }
    var noWifiMessage: String { get }
    var cancelButtonTitle: String { get }
    var yesContinueButtonTitle: String { get }
    var contentItemId: Int? { get }

    var isBookmarked: Bool { get }
    var isDownloaded: Bool { get }
    var isLoggedIn: Bool { get }
    var delegate: StreamVideoInteractorDelegate? { get set }
    func didTapDownload()
    func didTapDownloadWithoutWiFi()
    func didTapBookmark()
}

final class StreamVideoInteractor {

    weak var delegate: StreamVideoInteractorDelegate?
    private let worker: StreamVideoWorker

    init(content: QDMContentItem?) {
        worker = StreamVideoWorker(content: content)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateDownloadStatus(_:)),
                                               name: .didUpdateDownloadStatus, object: nil)
    }

    var downloadButtonTitle: String {
        switch worker.downloadStatus {
        case .NONE, .WAITING: return worker.downloadButtonTitle
        case .DOWNLOADING: return worker.downloadingButtonTitle
        case .DOWNLOADED: return worker.downloadedButtonTitle
        }
    }

    var isBookmarked: Bool {
        return worker.isBookmarked
    }

    var isDownloaded: Bool {
        return worker.downloadStatus == .DOWNLOADED
    }

    var isLoggedIn: Bool {
        return worker.isLoggedIn
    }

    var noWifiTitle: String {
        return worker.noWifiTitle
    }
    var noWifiMessage: String {
        return worker.noWifiMessage
    }

    var cancelButtonTitle: String {
        return worker.cancelButtonTitle
    }

    var yesContinueButtonTitle: String {
        return worker.yesContinueButtonTitle
    }

    var contentItemId: Int? {
        return worker.contentItemId
    }
}

extension StreamVideoInteractor: StreamVideoInteractorInterface {

    func didTapDownload() {
        if worker.downloadStatus == .DOWNLOADING {
            downloadItem()
            return
        }

        switch worker.reachabilityStatus {
        case .ethernetOrWiFi:
            downloadItem()
        case .wwan:
            delegate?.askUserToDownloadWithoutWiFi(interactor: self)
        case .notReachable:
            delegate?.showNoInternetConnectionAlert(interactor: self)
        }
    }

    func didTapDownloadWithoutWiFi() {
        downloadItem()
    }

    func didTapBookmark() {
        worker.toggleBookmark { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didUpdateData(interactor: strongSelf)
        }
    }
}

private extension StreamVideoInteractor {
    func downloadItem() {
        worker.downloadItem { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didUpdateData(interactor: strongSelf)
        }
    }

    @objc func didUpdateDownloadStatus(_ notification: Notification) {
        guard let map = notification.object as? [String: QDMDownloadStatus] else {
            return
        }
        let passiveItems = map.values.filter { (status) -> Bool in
            switch status.status {
            case .DOWNLOADED, .NONE:
                return true
            case .DOWNLOADING, .WAITING:
                return false
            }
        }
        if !passiveItems.isEmpty {
            worker.updateItemDownloadStatus { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.didUpdateData(interactor: strongSelf)
            }
        }
    }
}
