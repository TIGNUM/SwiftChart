//
//  LeaderWisdomTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class LeaderWisdomTableViewCell: BaseDailyBriefCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var videoThumbnailImageView: UIImageView!
    @IBOutlet private weak var videoTitle: UILabel!
    @IBOutlet private weak var videoDurationButton: UIButton!
    @IBOutlet private weak var audioButton: AnimatedButton!
    @IBOutlet private weak var audioView: UIView!
    @IBOutlet private weak var videoView: UIView!
    private var mediaURL: URL?
    private var duration: Double?
    private var remoteID: Int?
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        audioButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 500)
    }

    func configure(with viewModel: LeaderWisdomCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: titleLabel)
        ThemeText.bespokeText.apply(viewModel?.subtitle, to: subtitleLabel)
        ThemeText.bespokeText.apply(viewModel?.description, to: descriptionLabel)
        videoView.isHidden = viewModel?.format != .video
        videoThumbnailImageView.isHidden = viewModel?.format != .video
        audioView.isHidden = viewModel?.format != .audio
        audioButton.isHidden = viewModel?.format != .audio
        titleLabel.isHidden = viewModel?.title == nil
        subtitleLabel.isHidden = viewModel?.subtitle == nil
        descriptionLabel.isHidden = viewModel?.description == nil
        videoTitle.text = viewModel?.videoTitle?.uppercased()
        duration = viewModel?.audioDuration ?? viewModel?.videoDuration
        remoteID = viewModel?.remoteID
        mediaURL = viewModel?.videoThumbnail
        videoDurationButton.isHidden = viewModel?.format != .video
        videoDurationButton.setTitle(viewModel?.durationString, for: .normal)
        let mediaDescription = String(format: "%02i:%02i", Int(duration ?? 0) / 60 % 60, Int(duration ?? 0) % 60)
        audioButton.setTitle(mediaDescription, for: .normal)
        videoThumbnailImageView.isHidden = viewModel?.format != .video
        videoThumbnailImageView.kf.setImage(with: mediaURL, placeholder: R.image.preloading())
        videoTitle.isHidden = viewModel?.format != .video
    }

    @IBAction func audioAction(_ sender: Any) {
        let media = MediaPlayerModel(title: videoTitle.text ?? "",
                                     subtitle: "",
                                     url: mediaURL,
                                     totalDuration: duration ?? 0, progress: 0, currentTime: 0, mediaRemoteId: remoteID ?? 0)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
        NotificationCenter.default.post(name: .showAudioFullScreen, object: media)
    }

    @IBAction func videoAction(_ sender: Any) {
        delegate?.videoAction(sender, videoURL: mediaURL, contentItem: nil)
    }
}

// MARK: - Private

private extension LeaderWisdomTableViewCell {

    func setAudioAsCompleteIfNeeded(remoteID: Int) {
        audioView.backgroundColor = .carbon
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            audioView.backgroundColor = .accent40
        }
    }
}
