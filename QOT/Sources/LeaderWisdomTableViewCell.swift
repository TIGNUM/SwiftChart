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
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(subtitleLabel)
        skeletonManager.addSubtitle(descriptionLabel)
        skeletonManager.addOtherView(audioView)
        skeletonManager.addOtherView(videoView)
    }

    func configure(with viewModel: LeaderWisdomCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: titleLabel)
        ThemeText.dailyBriefSubtitle.apply(model.subtitle, to: subtitleLabel)
        ThemeText.dailyBriefSubtitle.apply(model.description, to: descriptionLabel)
        videoView.isHidden = model.format != .video
        videoThumbnailImageView.isHidden = model.format != .video
        audioView.isHidden = model.format != .audio
        audioButton.isHidden = model.format != .audio
        titleLabel.isHidden = model.title == nil
        subtitleLabel.isHidden = model.subtitle == nil
        descriptionLabel.isHidden = model.description == nil
        videoTitle.text = model.videoTitle?.uppercased()
        duration = model.audioDuration ?? model.videoDuration
        remoteID = model.remoteID
        mediaURL = model.videoThumbnail
        videoDurationButton.isHidden = model.format != .video
        videoDurationButton.setTitle(model.durationString, for: .normal)
        let mediaDescription = String(format: "%02i:%02i", Int(duration ?? 0) / 60 % 60, Int(duration ?? 0) % 60)
        audioButton.setTitle(mediaDescription, for: .normal)
        videoThumbnailImageView.isHidden = model.format != .video
        skeletonManager.addOtherView(videoThumbnailImageView)
        videoThumbnailImageView.kf.setImage(with: mediaURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil) { [weak self] (_) in
            self?.skeletonManager.hide()
        }
        videoTitle.isHidden = model.format != .video
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
