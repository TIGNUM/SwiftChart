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

extension UIViewController {

    @discardableResult
    func stream(videoURL: URL, contentItem: ContentItem?, pageName: PageName) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController(pageName: pageName, contentItem: contentItem)
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
