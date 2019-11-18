//
//  LeaderWisdomTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class LeaderWisdomTableViewCell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
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
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(descriptionLabel)
        skeletonManager.addOtherView(audioView)
        skeletonManager.addOtherView(videoView)
    }

    func configure(with viewModel: LeaderWisdomCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(),
                                  subtitle: model.subtitle)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefSubtitle.apply(model.subtitle, to: baseHeaderView?.subtitleTextView)
        ThemeText.dailyBriefSubtitle.apply(model.description, to: descriptionLabel)
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        videoView.isHidden = model.format != .video
        videoThumbnailImageView.isHidden = model.format != .video
        audioView.isHidden = model.format != .audio
        audioButton.isHidden = model.format != .audio
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
        videoThumbnailImageView.setImage(url: mediaURL,
                                         skeletonManager: self.skeletonManager) { (_) in /* */}
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
