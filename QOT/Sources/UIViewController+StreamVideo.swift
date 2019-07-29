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

final class MediaPlayerViewController: AVPlayerViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let navigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                  rightBarButtonItems: [],
                                                  backgroundColor: .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(.init(name: .willDismissPlayerController))
    }
}

extension UIViewController {

    @discardableResult
    func stream(videoURL: URL, contentItem: ContentItem?, pageName: PageName) -> MediaPlayerViewController {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        let player = AVPlayer(url: videoURL)
        let playerController = MediaPlayerViewController(pageName: pageName, contentItem: contentItem)
        playerController.player = player
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        present(playerController, animated: true) {
            player.volume = 1
            player.play()
        }
        addOverlay(to: playerController)
        return playerController
    }

    func presentNoInternetConnectionAlert(in playerViewController: AVPlayerViewController) {
        showAlert(type: .noNetworkConnectionFile, handler: {
            playerViewController.dismiss(animated: true, completion: nil)
        })
    }

    private func addOverlay(to playerController: AVPlayerViewController) {
        let overlay = MediaPlayerOverlay.instantiateFromNib()
        overlay.delegate = self
        if let contentView = playerController.contentOverlayView {
            playerController.contentOverlayView?.addSubview(overlay)
            overlay.bottomAnchor == contentView.safeBottomAnchor - playerController.view.frame.height / 6
            overlay.trailingAnchor == contentView.trailingAnchor
            overlay.leadingAnchor == contentView.leadingAnchor
        }
    }
}

extension UIViewController: MediaPlayerOverlayDelegate {
    func showAlert() {
        showAlert(type: .comingSoon)
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
