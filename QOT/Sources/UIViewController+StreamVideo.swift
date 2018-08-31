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
