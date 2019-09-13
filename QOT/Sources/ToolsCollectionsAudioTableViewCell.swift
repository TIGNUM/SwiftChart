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
    @IBOutlet weak var audioView: AudioButton!
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet private weak var audioLabel: UILabel!
    private var mediaURL: URL?
    private var title: String?
    private var remoteID: Int = 0
    private var categoryTitle = ""
    private var duration: Double = 0
    private var isPlaying: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        audioView.corner(radius: 20)
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
                   isPlaying: Bool?) {
        self.categoryTitle = categoryTitle
        self.mediaURL = mediaURL
        self.title = title
        self.remoteID = remoteID
        self.duration = duration
        self.isPlaying = isPlaying
        if isPlaying == true {
            audioView.backgroundColor = .accent40
        } else { audioView.backgroundColor = .carbon
        }
        ThemeText.qotTools.apply(title.uppercased(), to: titleLabel)
        ThemeText.qotToolsSectionSubtitle.apply(timeToWatch, to: detailLabel)
        setAudioAsCompleteIfNeeded(remoteID: remoteID)
        mediaIconImageView.image = R.image.ic_audio_grey()
        let mediaDescription = String(format: "%02i:%02i", Int(duration) / 60, Int(duration) % 60)
        audioLabel.attributedText = NSAttributedString(string: mediaDescription,
                                                       letterSpacing: 0.4,
                                                       font: .apercuMedium(ofSize: 12),
                                                       textColor: .accent,
                                                       alignment: .center)
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
        if isPlaying == true {
            audioView.backgroundColor = .accent40
        } else { audioView.backgroundColor = .carbon
        }
    }

    func makePDFCell() {
        mediaIconImageView.image = R.image.ic_read_grey()
        audioView.isHidden = true
        audioButton.isHidden = true
    }
}

// MARK: - Private

private extension ToolsCollectionsAudioTableViewCell {
    func setAudioAsCompleteIfNeeded(remoteID: Int) {
        audioView.backgroundColor = .carbon
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            audioView.backgroundColor = UIColor.accent.withAlphaComponent(0.4)
        }
    }
}
