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
    private var remoteID: Int = .zero
    private var duration: Double = .zero
    private var categoryTitle = String.empty
    private var isRead = false
    weak var delegate: IsPlayingDelegate?
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        audioView.corner(radius: 20)
        ThemeView.level2.apply(self)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(detailLabel)
        skeletonManager.addOtherView(mediaIconImageView)
        skeletonManager.addOtherView(audioView)
        skeletonManager.addOtherView(audioLabel)
        skeletonManager.addOtherView(readCheckMark)
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

    func configure(categoryTitle: String?,
                   title: String?,
                   timeToWatch: String?,
                   mediaURL: URL?,
                   duration: Double?,
                   mediaItemId: Int?,
                   isRead: Bool,
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
        ThemeText.articleRelatedDetailInStrategy.apply(timeText, to: detailLabel)
        mediaIconImageView.image = R.image.ic_seen_of()
        checkIfRead()
        showDuration(durationValue)
        checkIfPlaying()
        setAudioAsCompleteIfNeeded(remoteID: id)
        skeletonManager.hide()
    }
}

// MARK: - Actions

extension StrategyContentTableViewCell {

    @IBAction func didTapAudioButton() {
        let media = MediaPlayerModel(title: title ?? String.empty,
                                     subtitle: categoryTitle,
                                     url: mediaURL,
                                     totalDuration: duration, progress: .zero, currentTime: .zero, mediaRemoteId: remoteID)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
    }
}

// MARK: - Private

private extension StrategyContentTableViewCell {
    func showDuration(_ duration: Double) {
        let text = String(format: "%i:%02i", Int(duration) / 60 % 60, Int(duration) % 60)
        isRead ? ThemeText.articleRelatedDetailInStrategyRead.apply(text, to: audioLabel) : ThemeText.audioBar.apply(text, to: audioLabel)
    }

    func setAudioAsCompleteIfNeeded(remoteID: Int) {
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            ThemeView.audioPlaying.apply(audioView)
            audioButton.layer.borderWidth = .zero
        }
    }

    private func checkIfPlaying() {
        if let isPlaying = delegate?.isPlaying(remoteID: remoteID) {
            if isPlaying {
                ThemeView.audioPlaying.apply(audioView)
                audioButton.layer.borderWidth = .zero
            } else {
                ThemeView.level1.apply(audioView)
                audioButton.layer.borderWidth = 1
            }
        }
    }

    private func checkIfRead() {
        ThemeTint.lightGrey.apply(readCheckMark)
        audioIcon.image = R.image.ic_audio()
        if isRead {
            ThemeText.articleStrategyRead.apply(title, to: titleLabel)
            ThemeButton.audioButtonGrey.apply(audioButton)
            audioButton.layer.borderWidth = .zero
            ThemeTint.lightGrey.apply(audioIcon)
            readCheckMark.alpha = 1
        } else {
            ThemeText.articleStrategyTitle.apply(title, to: titleLabel)
            ThemeButton.audioButtonStrategy.apply(audioButton)
            ThemeBorder.white.apply(audioButton)
            ThemeTint.white.apply(audioIcon)
            readCheckMark.alpha = .zero
        }
    }
}
