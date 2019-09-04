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
        AppDelegate.appState.orientationManager.videos()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(.init(name: .willDismissPlayerController))
        AppDelegate.appState.orientationManager.regular()

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
        overlayControls?.configure(downloadTitle: interactor.downloadButtonTitle, isBokmarked: interactor.isBookmarked)
    }

    func askUserToDownloadWithoutWiFi(interactor: StreamVideoInteractorInterface) {
        // TODO: Replace with QOT alert: https://tignum.atlassian.net/browse/QOT-1748
        let alert = UIAlertController(title: interactor.noWifiTitle, message: interactor.noWifiMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: interactor.cancelButtonTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: interactor.yesContinueButtonTitle, style: .default, handler: { (_) in
            interactor.didTapDownloadWithoutWiFi()
        }))
        self.present(alert, animated: true, completion: nil)
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
    func stream(videoURL: URL, contentItem: QDMContentItem?, _ pageName: PageName? = nil) -> MediaPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let playerController = MediaPlayerViewController(contentItem: contentItem)
        let interactor = StreamVideoInteractor(content: contentItem)
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
            overlay.configure(downloadTitle: interactor.downloadButtonTitle, isBokmarked: interactor.isBookmarked)
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
