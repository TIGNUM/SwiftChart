//
//  RegisterIntroMediaTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

final class RegisterIntroMediaTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mediaContentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var playerController = AVPlayerViewController()

    func configure(title: String?, body: String?, videoURL: String?) {
        ThemeText.registerIntroTitle.apply(title, to: titleLabel)
        ThemeText.registerIntroBody.apply(body, to: descriptionLabel)
        if let url = URL.init(string: videoURL ?? "") {
            embededableMediaPlayer(videoURL: url)
        }
    }

    func stopPlaying() {
        playerController.player?.pause()
    }

    func startPlayingFromBeggining() {
        playerController.player?.seek(to: kCMTimeZero)
        playerController.player?.play()
    }
}

private extension RegisterIntroMediaTableViewCell {
    func embededableMediaPlayer(videoURL: URL) {
        playerController.player = AVPlayer(url: videoURL)

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        _ = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.playerController.player?.currentItem, queue: .main) { [weak self] _ in
            self?.startPlayingFromBeggining()
        }
        playerController.showsPlaybackControls = false
        mediaContentView.addSubview(playerController.view)
        playerController.view.frame = mediaContentView.bounds
        playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerController.player?.play()
    }
}
