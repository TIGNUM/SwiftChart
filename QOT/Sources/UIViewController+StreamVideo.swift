//
//  UIViewController+StreamVideo.swift
//  QOT
//
//  Created by karmic on 18.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import AVFoundation
import AVKit
import qot_dal

final class MediaPlayerViewController: AVPlayerViewController, ScreenZLevelOverlay {
    var overlayControls: MediaPlayerOverlay?
    var interactor: StreamVideoInteractorInterface? {
        didSet {
            interactor?.delegate = self
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppCoordinator.orientationManager.videos()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(.init(name: .willDismissPlayerController))
        AppCoordinator.orientationManager.regular()

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let controls = overlayControls {
            self.view.bringSubview(toFront: controls)
        }
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_ITEM
        pageTrack.associatedValueId = interactor?.contentItemId
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

extension MediaPlayerViewController: StreamVideoInteractorDelegate {

    func didUpdateData(interactor: StreamVideoInteractorInterface) {
        overlayControls?.configure(downloadTitle: interactor.downloadButtonTitle,
                                   isBokmarked: interactor.isBookmarked,
                                   isDownloaded: interactor.isDownloaded)
    }

    func askUserToDownloadWithoutWiFi(interactor: StreamVideoInteractorInterface) {
        let cancel = QOTAlertAction(title: interactor.cancelButtonTitle)
        let buttonContinue = QOTAlertAction(title: interactor.yesContinueButtonTitle) { [weak self] (_) in
            self?.interactor?.didTapDownloadWithoutWiFi()
        }
        QOTAlert.show(title: interactor.noWifiTitle, message: interactor.noWifiMessage, bottomItems: [cancel, buttonContinue])
    }

    func showNoInternetConnectionAlert(interactor: StreamVideoInteractorInterface) {
        self.showNoInternetConnectionAlert()
    }
}

extension MediaPlayerViewController: MediaPlayerOverlayDelegate {

    func downloadMedia() {
        interactor?.didTapDownload()
    }

    func bookmarkMedia() {
        interactor?.didTapBookmark()
    }
}

extension UIViewController {
    @discardableResult
    func stream(videoURL: URL, contentItem: QDMContentItem?) -> MediaPlayerViewController? {
        let interactor = StreamVideoInteractor(content: contentItem)
        guard QOTReachability().isReachable || interactor.isDownloaded else {
            self.showNoInternetConnectionAlert()
            return nil
        }
        let player = AVPlayer(url: videoURL)
        let playerController = MediaPlayerViewController(contentItem: contentItem)
        playerController.interactor = interactor
        playerController.player = player

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }

        present(playerController, animated: true) {
            playerController.trackPage()
            player.volume = 1
            player.play()
        }
        if interactor.isLoggedIn {
            addOverlay(to: playerController)
        }
        return playerController
    }

    func presentNoInternetConnectionAlert(in playerViewController: AVPlayerViewController) {
        showAlert(type: .noNetworkConnectionFile, handler: {
            playerViewController.dismiss(animated: true, completion: nil)
        })
    }

    private func addOverlay(to playerController: MediaPlayerViewController) {
        let overlay = MediaPlayerOverlay.instantiateFromNib()
        overlay.delegate = playerController
        playerController.overlayControls = overlay
        if let contentView = playerController.view {
            contentView.addSubview(overlay)
            overlay.bottomAnchor == contentView.safeBottomAnchor - playerController.view.frame.height / 6
            overlay.trailingAnchor == contentView.trailingAnchor
            overlay.leadingAnchor == contentView.leadingAnchor
            overlay.heightAnchor.constraint(equalToConstant: MediaPlayerOverlay.height).isActive = true
        }
        if let interactor = playerController.interactor {
            overlay.configure(downloadTitle: interactor.downloadButtonTitle,
                              isBokmarked: interactor.isBookmarked,
                              isDownloaded: interactor.isDownloaded)
        }
    }
}

class AVPlayerObserver: NSObject {
    private var updateHandler: ((AVPlayerItem) -> Void)?
    let playerItem: AVPlayerItem
    var observation: NSKeyValueObservation?

    init(playerItem: AVPlayerItem) {
        self.playerItem = playerItem
        super.init()
        observation = playerItem.observe(\.status, options: [.initial]) { [weak self] (item, changes) in
            self?.updateHandler?(playerItem)
        }
    }

    deinit {
        observation?.invalidate()
    }

    func onStatusUpdate(_ closure: @escaping (AVPlayerItem) -> Void) {
        updateHandler = closure
    }
}
