//
//  CoachMarkCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 31.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import AVFoundation

final class CoachMarkCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private var videoView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    var player: AVQueuePlayer? = AVQueuePlayer()
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    private let mediaExtension = "mp4"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlayer()
        playerLayer?.frame = videoView.bounds
        playerLayer?.contentsGravity = kCAGravityCenter
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    func configure(mediaName: String, title: String, subtitle: String) {
        setPlayerLooper(mediaName)
        setupLabels(title, subtitle: subtitle)
        player?.play()
    }
}

// MARK: - Private
private extension CoachMarkCollectionViewCell {
    func setupPlayer() {
        let playerLayer = AVPlayerLayer(player: player)
        videoView.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
    }

    func setPlayerLooper(_ mediaName: String?) {
        if let media = Bundle.main.url(forResource: mediaName, withExtension: mediaExtension),
            let player = player {
            let playerItem = AVPlayerItem(url: media)
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        } else {
            playerLooper = nil
        }
    }

    func setupLabels(_ title: String?, subtitle: String?) {
        ThemeText.coachMarkTitle.apply(title, to: titleLabel)
        ThemeText.coachMarkSubtitle.apply(subtitle, to: subtitleLabel)
    }
}
