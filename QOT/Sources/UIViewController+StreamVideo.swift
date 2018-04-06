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

extension UIViewController {

    @discardableResult
    func stream(videoURL: URL) -> AVPlayerViewController {
        UIApplication.shared.statusBarStyle = .lightContent
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player

        present(playerController, animated: true) {
            player.play()
        }
        return playerController
    }

    func presentNoInternetConnectionAlert(in playerViewController: AVPlayerViewController) {
        showAlert(type: .noNetworkConnectionFile, handler: {
            playerViewController.dismiss(animated: true, completion: nil)
        })
    }
}

class AVPlayerObserver: NSObject {

    private var updateHandler: ((AVPlayerItem) -> Void)?
    let playerItem: AVPlayerItem

    init(playerItem: AVPlayerItem) {
        self.playerItem = playerItem
        super.init()

        playerItem.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
    }

    deinit {
        playerItem.removeObserver(self, forKeyPath: "status")
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            updateHandler?(playerItem)
        }
    }

    func onStatusUpdate(_ closure: @escaping (AVPlayerItem) -> Void) {
        updateHandler = closure
    }
}

extension NSError {

    var isNoNetworkError: Bool {
        switch (code, domain) {
        case (NSURLErrorNotConnectedToInternet, NSURLErrorDomain):
            return true
        default:
            return false
        }
    }
}
