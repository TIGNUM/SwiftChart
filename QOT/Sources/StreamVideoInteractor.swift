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
    func showBookmarkSelectionViewController(with contentItemId: Int, _ completion: @escaping (Bool) -> Void)
}

protocol StreamVideoInteractorInterface {
    var downloadButtonTitle: String { get }
    var noWifiTitle: String { get }
    var noWifiMessage: String { get }
    var cancelButtonTitle: String { get }
    var yesContinueButtonTitle: String { get }
    var contentItemId: Int? { get }
    var contentFormat: ContentFormat? { get }

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
    private let presenter: StreamVideoPresenter
    private var downloadMap: [String: QDMDownloadStatus] = [:]

    init(worker: StreamVideoWorker,
         presenter: StreamVideoPresenter) {
        self.worker = worker
        self.presenter = presenter
        _ = NotificationCenter.default.addObserver(forName: .didUpdateDownloadStatus,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didUpdateDownloadStatus(notification)
        }
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

    var contentFormat: ContentFormat? {
        return worker.contentFormat
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
        guard let contentItemId = contentItemId, contentItemId != .zero else { return }
        // FIXME: shows book mark selection
        TeamService.main.getTeams { [weak self] (teams, _, _) in
            let completion: (Bool) -> Void = { [weak self] (isChanged) in
                guard let strongSelf = self else { return }
                NotificationCenter.default.post(name: .didUpdateMyLibraryData, object: nil)
                if strongSelf.isBookmarked, isChanged, strongSelf.worker.wasBookmarkedOnce == false {
                    strongSelf.showAddedAlert()
                    strongSelf.worker.wasBookmarkedOnce = true
                }
                strongSelf.delegate?.didUpdateData(interactor: strongSelf)
            }
            if teams?.isEmpty ?? true {
                self?.worker.toggleBookmark { completion(true) }
            } else {
                self?.delegate?.showBookmarkSelectionViewController(with: contentItemId) { [weak self] isChanged in
                    self?.worker.updateBookmarks {
                        completion(isChanged)
                    }
                }
            }
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
            case .DOWNLOADED,
                 .NONE:
                return true
            case .DOWNLOADING,
                 .WAITING:
                return false
            }
        }

        if !passiveItems.isEmpty {
            worker.updateItemDownloadStatus { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.didUpdateData(interactor: strongSelf)
                if strongSelf.worker.downloadStatus == .DOWNLOADED &&
                    !strongSelf.worker.didShowDownloadDestinationAlertOnce {
                        strongSelf.showAddedAlert()
                        strongSelf.worker.didShowDownloadDestinationAlertOnce = true
                }
            }
        }
    }

    func showAddedAlert() {
        presenter.showAddedAlert()
    }
}
