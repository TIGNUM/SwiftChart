//
//  ToolsCollectionsItemTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsAudioTableViewCell: UITableViewCell, Dequeueable {

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
    private var categoryTitle = ""
    weak var toolViewDelegate: AudioToolPlayerDelegate?

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
                   remoteID: Int) {
        self.categoryTitle = categoryTitle
        self.mediaURL = mediaURL
        self.title = title
        self.remoteID = remoteID
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.5,
                                                       font: .apercuLight(ofSize: 16),
                                                       lineSpacing: 8,
                                                       textColor: .carbon,
                                                       alignment: .left)
        detailLabel.attributedText = NSAttributedString(string: timeToWatch,
                                                        letterSpacing: 0.4,
                                                        font: .apercuMedium(ofSize: 12),
                                                        textColor: UIColor.carbon.withAlphaComponent(0.4),
                                                        alignment: .left)
        setAudioAsCompleteIfNeeded(remoteID: remoteID)
        mediaIconImageView.image = R.image.ic_audio_grey()
        let mediaDescription = String(format: "%02i:%02i", Int(duration) / 60 % 60, Int(duration) % 60)
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
        toolViewDelegate?.didTabPlayPause(categoryTitle: categoryTitle,
                                      title: title ?? "",
                                      audioURL: mediaURL,
                                      remoteID: remoteID)
    }

    func makePDFCell() {
        mediaIconImageView.image = R.image.ic_read_grey()
        audioView.isHidden = true
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
