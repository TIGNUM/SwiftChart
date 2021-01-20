//
//  UIViewController+StreamVideo.swift
//  QOT
//
//  Created by karmic on 18.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import qot_dal

protocol MediaPlayerViewControllerInterface: class {
    func showInfoAlert()
}

final class MediaPlayerViewController: AVPlayerViewController {
    var overlayControls: MediaPlayerOverlay?
    var videoGravityObserver: NSKeyValueObservation?
    var zoomed: Bool = false
    var avPlayerObserver: AVPlayerObserver?

    var interactor: StreamVideoInteractorInterface? {
        didSet {
            interactor?.delegate = self
        }
    }

    init(configure: Configurator<MediaPlayerViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppCoordinator.orientationManager.videos()
        addVideoGravityObserver()
        addSwipeGestureRecognizer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(.init(name: .willDismissPlayerController))
        AppCoordinator.orientationManager.regular()
        self.player?.pause()

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        videoGravityObserver?.invalidate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let controls = overlayControls {
            self.view.bringSubviewToFront(controls)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if overlayControls?.buttonsHidden == true {
            self.overlayControls?.buttonsAnimate()
        } else {
            self.overlayControls?.buttonsHide()
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

    func addVideoGravityObserver() {
        videoGravityObserver = self.observe(\.videoGravity) { [weak self] (_, _) in
            self?.overlayControls?.buttonsForScreen()
        }
    }

    func addSwipeGestureRecognizer() {
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(didSwipeDown))
        swipeDownGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }

    @objc func didSwipeDown() {
        let contentType: QDMUserEventTracking.ValueType = interactor?.contentFormat == .video ? .VIDEO : .AUDIO
        trackUserEvent(.CLOSE, value: interactor?.contentItemId, valueType: contentType, action: .SWIPE)
        dismiss(animated: true, completion: nil)
    }
}

extension MediaPlayerViewController: MediaPlayerViewControllerInterface {

    func showInfoAlert() {
        showAddedAlert()
    }
}

extension MediaPlayerViewController: StreamVideoInteractorDelegate {
    func didUpdateData(interactor: StreamVideoInteractorInterface) {
        overlayControls?.configure(downloadTitle: interactor.downloadButtonTitle,
                                   isBokmarked: interactor.isBookmarked,
                                   isDownloaded: interactor.isDownloaded)
        refreshBottomNavigationItems()
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

    func showBookmarkSelectionViewController(with contentItemId: Int, _ completion: @escaping (Bool) -> Void) {
        guard let viewController = R.storyboard.bookMarkSelection.bookMarkSelectionViewController() else { return }
        let config = BookMarkSelectionConfigurator.make(contentId: contentItemId, contentType: .CONTENT_ITEM)
        config(viewController) { [weak self] (isChanged) in
            self?.trackPage()
            completion(isChanged)
        }
        self.present(viewController, animated: true, completion: nil)
    }
}

extension MediaPlayerViewController: MediaPlayerOverlayDelegate {
    func downloadMedia() {
        trackUserEvent(.DOWNLOAD, value: interactor?.contentItemId, stringValue: .SELECT, valueType: .VIDEO, action: .TAP)
        interactor?.didTapDownload()
    }

    func bookmarkMedia() {
        let value: QDMUserEventTracking.Name = interactor?.isBookmarked == true ? .DESELECT : .SELECT
        trackUserEvent(.BOOKMARK, value: interactor?.contentItemId, stringValue: value, valueType: .VIDEO, action: .TAP)
        interactor?.didTapBookmark()
    }
}

extension UIViewController {
    @discardableResult
    func stream(videoURL: URL, contentItem: QDMContentItem?) -> MediaPlayerViewController? {
        let configurator = StreamVideoConfigurator.make(content: contentItem)
        let playerController = MediaPlayerViewController(configure: configurator)
        let interactor = playerController.interactor
        guard QOTReachability().isReachable || interactor?.isDownloaded ?? false else {
            self.showNoInternetConnectionAlert()
            return nil
        }
        let player = AVPlayer(url: videoURL)
        observe(controller: playerController, player: player, contentItem: contentItem)
        playerController.player = player

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }

        if (self as? BaseDailyBriefDetailsViewController) != nil {
            playerController.modalPresentationStyle = .overFullScreen
            self.navigationController?.presentModal(playerController, from: self, animated: true, completion: {
                playerController.trackPage()
                player.volume = 1
                player.play()
            })
        } else {
            presentSwizzled(viewControllerToPresent: playerController, animated: true, completion: {
                playerController.trackPage()
                player.volume = 1
                player.play()
            })
        }
        if interactor?.isLoggedIn ?? false {
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
            overlay.frame = CGRect(x: 0,
                                   y: (contentView.frame.height * 0.71) + MediaPlayerOverlay.height,
                                   width: contentView.frame.width,
                                   height: MediaPlayerOverlay.height)
        }
        if let interactor = playerController.interactor {
            overlay.configure(downloadTitle: interactor.downloadButtonTitle,
                              isBokmarked: interactor.isBookmarked,
                              isDownloaded: interactor.isDownloaded)
        }
    }

    private func observe(controller: MediaPlayerViewController, player: AVPlayer, contentItem: QDMContentItem?) {
        controller.avPlayerObserver = AVPlayerObserver(player: player)
        controller.avPlayerObserver?.onChanges { [weak self] (player) in
            if player.timeControlStatus == .paused {
                self?.trackUserEvent(.PAUSE, value: contentItem?.remoteID, valueType: .VIDEO, action: .TAP)
                controller.overlayControls?.buttonsShow()
            }
            if player.timeControlStatus == .playing {
                self?.trackUserEvent(.PLAY, value: contentItem?.remoteID, valueType: .VIDEO, action: .TAP)
                controller.overlayControls?.buttonsHide()
            }
        }
    }
}

class AVPlayerObserver: NSObject {
    private var updateHandler: ((AVPlayerItem) -> Void)?
    private var playerUpdateHandler: ((AVPlayer) -> Void)?
    var observation: NSKeyValueObservation?
    var playerObservation: NSKeyValueObservation?

    init(playerItem: AVPlayerItem) {
        super.init()
        observation = playerItem.observe(\.status, options: [.initial]) { [weak self] (item, changes) in
            self?.updateHandler?(playerItem)
        }
    }

    init(player: AVPlayer) {
        super.init()
        playerObservation = player.observe(\.timeControlStatus, options: [.new, .old]) { [weak self] (player, changes) in
             self?.playerUpdateHandler?(player)
         }
    }

    deinit {
        observation?.invalidate()
    }

    func onChanges(_ closure: @escaping (AVPlayer) -> Void) {
        playerUpdateHandler = closure
    }

    func onStatusUpdate(_ closure: @escaping (AVPlayerItem) -> Void) {
        updateHandler = closure
    }
}
