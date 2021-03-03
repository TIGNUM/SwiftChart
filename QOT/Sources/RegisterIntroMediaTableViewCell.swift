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
    @IBOutlet weak var soundToggleButton: UIButton!
    private var avPlayerObserver: AVPlayerObserver?
    var playerController = AVPlayerViewController()
    weak var delegate: RegisterIntroUserEventTrackDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        addRecognizers()
    }

    func addRecognizers() {
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapMediaContentView))
        mediaContentView.addGestureRecognizer(tapRecognizer)

        let swipeDownGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(didSwipeDown(_:)))
        swipeDownGestureRecognizer.direction = .down
        playerController.view.addGestureRecognizer(swipeDownGestureRecognizer)
    }

    func configure(title: String?, body: String?, videoURL: String?) {
        ThemeText.registerIntroTitle.apply(title?.lowercased().capitalizingFirstLetter(), to: titleLabel)
        ThemeText.registerIntroBody.apply(body, to: descriptionLabel)
        if let url = URL.init(string: videoURL ?? String.empty) {
            embededableMediaPlayer(videoURL: url)
        }
    }

    @IBAction func didTapSoundToggleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        playerController.player?.isMuted = !sender.isSelected

        if playerController.player?.isMuted == true {
            delegate?.didMuteVideo()
        } else {
            delegate?.didUnMuteVideo()
        }
    }

    @objc func didSwipeDown(_ notification: NSNotification) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    @objc func didTapMediaContentView() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    func stopPlaying() {
        playerController.player?.pause()
    }

    func startPlayingFromBeggining() {
        playerController.player?.seek(to: CMTime.zero)
        playerController.player?.play()
    }
}

private extension RegisterIntroMediaTableViewCell {
    func embededableMediaPlayer(videoURL: URL) {
        playerController.player = AVPlayer(url: videoURL)

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        _ = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                   object: self.playerController.player?.currentItem,
                                                   queue: .main) { [weak self] _ in
            self?.startPlayingFromBeggining()
        }
        playerController.showsPlaybackControls = false
        mediaContentView.addSubview(playerController.view)
        playerController.view.frame = mediaContentView.bounds
        playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerController.player?.play()
        playerController.player?.isMuted = true
        observeAVPlayer(player: playerController.player)
    }

    func observeAVPlayer(player: AVPlayer?) {
        guard let player = player else { return }
        avPlayerObserver = AVPlayerObserver(player: player)
        avPlayerObserver?.onChanges { [weak self] (player) in
            if player.timeControlStatus == .paused {
                self?.delegate?.didPauseVideo()
            }
            if player.timeControlStatus == .playing {
                self?.delegate?.didPlayVideo()
            }
        }
    }
}
