//
//  StrategyContentTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyContentTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var mediaIconImageView: UIImageView!
    @IBOutlet private weak var audioView: UIView!
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet private weak var audioLabel: UILabel!
    @IBOutlet private weak var readCheckMark: UIImageView!
    @IBOutlet private weak var audioIcon: UIImageView!
    private var mediaURL: URL?
    private var timeToWatch: String?
    private var title: String?
    private var remoteID: Int = 0
    private var duration: Double = 0
    private var categoryTitle = ""
    private var isRead: Bool?
    weak var delegate: IsPlayingDelegate?
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        audioView.corner(radius: 20)
        ThemeView.level2.apply(self)
        contentView.backgroundColor = .clear
        audioIcon.image = R.image.ic_audio_grey_light()
        selectionStyle = .none
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(detailLabel)
        skeletonManager.addOtherView(mediaIconImageView)
        skeletonManager.addOtherView(audioView)
        skeletonManager.addOtherView(audioLabel)
        checkIfPlaying()
        checkIfRead()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        readCheckMark.isHidden = false
        setAudioAsCompleteIfNeeded(remoteID: remoteID)
        selectedBackgroundView = nil
        checkIfPlaying()
        checkIfRead()
    }

    private func checkIfPlaying() {
        if let isPlaying = delegate?.isPlaying(remoteID: remoteID) {
            isPlaying ? ThemeView.audioPlaying.apply(audioView) : ThemeView.level1.apply(audioView)
        }
    }

    private func checkIfRead() {
        guard let isRead = isRead else { return }
        if isRead {
            ThemeText.articleStrategyRead.apply(title, to: titleLabel)
//             TODO change color of time to watch text
            ThemeText.articleRelatedDetailInStrategy.apply(timeToWatch, to: detailLabel)
            ThemeButton.audioButtonGrey.apply(audioButton)
            readCheckMark.alpha = 1
        } else {
            ThemeButton.audioButtonStrategy.apply(audioButton)
            ThemeBorder.accent.apply(audioButton)
            ThemeText.articleRelatedDetailInStrategy.apply(timeToWatch, to: detailLabel)
            ThemeText.articleStrategyTitle.apply(title, to: titleLabel)
            audioIcon.image = R.image.ic_audio()
            ThemeView.level1.apply(audioView)}
            readCheckMark.alpha = 0
    }

    func configure(categoryTitle: String?,
                   title: String?,
                   timeToWatch: String?,
                   mediaURL: URL?,
                   duration: Double?,
                   mediaItemId: Int?,
                   isRead: Bool?,
                   delegate: IsPlayingDelegate?) {
        guard let category = categoryTitle,
            let titleText = title,
            let timeText = timeToWatch,
            let durationValue = duration,
            let id = mediaItemId else {
                return
        }
        self.isRead = isRead
        self.delegate = delegate
        self.categoryTitle = category
        self.mediaURL = mediaURL
        self.title = titleText
        self.remoteID = id
        self.duration = durationValue
        self.timeToWatch = timeToWatch
        selectionStyle = .gray
        let bkView = UIView()
        ThemeView.level2Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.hide()
        checkIfRead()
        ThemeText.articleRelatedDetailInStrategy.apply(timeText, to: detailLabel)
        mediaIconImageView.image = R.image.ic_seen_of()
        showDuration(durationValue)
        checkIfPlaying()
        setAudioAsCompleteIfNeeded(remoteID: id)
    }
}

// MARK: - Actions

extension StrategyContentTableViewCell {

    @IBAction func didTapAudioButton() {
        let media = MediaPlayerModel(title: title ?? "",
                                     subtitle: categoryTitle,
                                     url: mediaURL,
                                     totalDuration: duration, progress: 0, currentTime: 0, mediaRemoteId: remoteID)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
    }
}

// MARK: - Private

private extension StrategyContentTableViewCell {
    func showDuration(_ duration: Double) {
        let text = String(format: "%i:%02i", Int(duration) / 60 % 60, Int(duration) % 60)
        ThemeText.audioBar.apply(text, to: audioLabel)
    }

    func setAudioAsCompleteIfNeeded(remoteID: Int) {
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            ThemeView.audioPlaying.apply(audioView)
        }
    }
}
