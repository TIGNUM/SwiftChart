//
//  SprintChallengeDay0VideoTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 07.12.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class SprintChallengeDay0VideoTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDurationLabel: UILabel!
    @IBOutlet weak var playIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func setupViews() {
        selectionStyle = .none
        playIconImageView.layer.cornerRadius = playIconImageView.frame.size.width / 2.0
        playIconImageView.backgroundColor = .actionBlue
        videoThumbnailImageView.layer.borderWidth = 1.0
        videoThumbnailImageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func configure(model: SprintChallengeViewModel.RelatedItemsModel) {
        if let thumbnailImageUrl = model.videoThumbnailImageUrl {
            videoThumbnailImageView.kf.setImage(with: URL.init(string: thumbnailImageUrl))
        }
        videoTitleLabel.text = model.title
        videoDurationLabel.text = model.durationString
    }
}
