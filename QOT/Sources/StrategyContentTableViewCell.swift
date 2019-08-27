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
    private var mediaURL: URL?
    private var title: String?
    private var remoteID: Int = 0
    private var duration: Double = 0
    private var categoryTitle = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.audioBar.apply(audioView)

        selectionStyle = .gray
        let bkView = UIView()
        bkView.backgroundColor = .accent04
        selectedBackgroundView = bkView
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setAudioAsCompleteIfNeeded(remoteID: remoteID)
    }

    func configure(categoryTitle: String,
                   title: String,
                   timeToWatch: String,
                   mediaURL: URL?,
                   duration: Double,
                   mediaItemId: Int) {
        self.categoryTitle = categoryTitle
        self.mediaURL = mediaURL
        self.title = title
        self.remoteID = mediaItemId
        self.duration = duration
        setAudioAsCompleteIfNeeded(remoteID: mediaItemId)
        ThemeText.articleRelatedTitle.apply(title, to: titleLabel)
        ThemeText.articleRelatedDetail.apply(timeToWatch, to: detailLabel)
        mediaIconImageView.image = R.image.ic_seen_of()
        showDuration(duration)
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
        audioView.backgroundColor = .carbon
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            audioView.backgroundColor = .sand30
        }
    }
}
