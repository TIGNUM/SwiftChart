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
    @IBOutlet private weak var labelIcon: UIImageView!
    private var mediaURL: URL?
    private var title: String?
    private var remoteID: Int = 0
    private var categoryTitle = String.empty
    private var duration: Double = 0
    weak var delegate: IsPlayingDelegate?
    @IBOutlet weak var audioLabelView: AudioButton!

    override func awakeFromNib() {
        super.awakeFromNib()
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
        ThemeText.qotTools.apply(title, to: titleLabel)
        ThemeText.qotToolsSectionSubtitle.apply(timeToWatch, to: detailLabel)
        mediaIconImageView.image = R.image.ic_audio()
        labelIcon.image = R.image.ic_audio()
        ThemeTint.black.apply(labelIcon)
        ThemeTint.darkGrey.apply(mediaIconImageView)
        let mediaDescription = String(format: "%02i:%02i", Int(duration) / 60, Int(duration) % 60)
        ThemeText.audioLabelLight.apply(mediaDescription, to: audioLabel)
        audioLabelView.corner(radius: 20, borderColor: .black, borderWidth: 1)
        setAudioAsCompleteIfNeeded(remoteID: remoteID)
    }
}

// MARK: - Actions

extension ToolsCollectionsAudioTableViewCell {

    @IBAction func didTapAudioButton(_ sender: UIButton) {
        let media = MediaPlayerModel(title: title ?? String.empty,
                                     subtitle: categoryTitle,
                                     url: mediaURL,
                                     totalDuration: duration, progress: 0, currentTime: 0, mediaRemoteId: remoteID)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
    }

    func makePDFCell() {
        mediaIconImageView.image = R.image.ic_read()
        ThemeTint.darkGrey.apply(mediaIconImageView)
        audioLabelView.isHidden = true
        audioButton.isHidden = true
    }
}

// MARK: - Private

private extension ToolsCollectionsAudioTableViewCell {
    func setAudioAsCompleteIfNeeded(remoteID: Int) {
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            audioLabelView.corner(radius: 20, borderColor: .lightGrey, borderWidth: 1)
            ThemeTint.lightGrey.apply(mediaIconImageView)
            ThemeTint.lightGrey.apply(labelIcon)
            audioLabel.textColor = .lightGrey
            titleLabel.textColor = .lightGrey
            detailLabel.textColor = .lightGrey
        }
    }
}
