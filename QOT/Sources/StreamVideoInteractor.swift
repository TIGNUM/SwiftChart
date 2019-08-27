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
}

protocol StreamVideoInteractorInterface {
    var downloadButtonTitle: String { get }
    var noWifiTitle: String { get }
    var noWifiMessage: String { get }
    var cancelButtonTitle: String { get }
    var yesContinueButtonTitle: String { get }

    var isBookmarked: Bool { get }
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
}

extension StreamVideoInteractor: StreamVideoInteractorInterface {

    func didTapDownload() {
        if worker.isConnectedToWiFi || worker.downloadStatus == .DOWNLOADING {
            downloadItem()
        } else {
            delegate?.askUserToDownloadWithoutWiFi(interactor: self)
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
}
