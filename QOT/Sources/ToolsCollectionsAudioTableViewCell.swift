//
//  ToolsCollectionsItemTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsAudioTableViewCell: BaseToolsTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var mediaIconImageView: UIImageView!
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet private weak var audioLabel: UILabel!
    private var mediaURL: URL?
    private var title: String?
    private var remoteID: Int = 0
    private var categoryTitle = ""
    private var duration: Double = 0
    weak var delegate: IsPlayingDelegate?
    @IBOutlet weak var audioLabelView: AudioButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        checkIfPlaying()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setAudioAsCompleteIfNeeded(remoteID: remoteID)
        checkIfPlaying()
    }

    private func checkIfPlaying() {
        if let isPlaying = delegate?.isPlaying(remoteID: remoteID) {
            isPlaying ? ThemeView.audioPlaying.apply(audioLabelView) : ThemeView.level1.apply(audioLabelView)
        }
    }

    func configure(categoryTitle: String,
                   title: String,
                   timeToWatch: String,
                   mediaURL: URL?,
                   duration: Double,
                   remoteID: Int,
                   delegate: IsPlayingDelegate?) {
        audioLabelView.isHidden = false
        audioLabelView.isUserInteractionEnabled = true
        self.categoryTitle = categoryTitle
        self.mediaURL = mediaURL
        self.title = title
        self.remoteID = remoteID
        self.duration = duration
        self.delegate = delegate
        ThemeText.qotTools.apply(title.uppercased(), to: titleLabel)
        ThemeText.qotToolsSectionSubtitle.apply(timeToWatch, to: detailLabel)
        mediaIconImageView.image = R.image.ic_audio_grey()
        checkIfPlaying()
        let mediaDescription = String(format: "%02i:%02i", Int(duration) / 60, Int(duration) % 60)
        ThemeText.audioLabel.apply(mediaDescription, to: audioLabel)
        setAudioAsCompleteIfNeeded(remoteID: remoteID)
    }
}

// MARK: - Actions

extension ToolsCollectionsAudioTableViewCell {

    @IBAction func didTapAudioButton(_ sender: UIButton) {
        let media = MediaPlayerModel(title: title ?? "",
                                     subtitle: categoryTitle,
                                     url: mediaURL,
                                     totalDuration: duration, progress: 0, currentTime: 0, mediaRemoteId: remoteID)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
    }

    func makePDFCell() {
        mediaIconImageView.image = R.image.ic_read_grey()
        audioLabelView.isHidden = true
        audioButton.isHidden = true
    }
}

// MARK: - Private

private extension ToolsCollectionsAudioTableViewCell {
    func setAudioAsCompleteIfNeeded(remoteID: Int) {
//        audioLabelView.isHidden = false
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            audioLabelView.backgroundColor = UIColor.accent.withAlphaComponent(0.4)
        }
    }
}
