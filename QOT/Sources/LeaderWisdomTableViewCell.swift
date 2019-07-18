//
//  LeaderWisdomTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol LeaderWisdomTableViewCellProtocol: class {
    func shouldPlayVideo(with url: URL?)
    func shouldPlayAudio()
}

final class LeaderWisdomTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var videoThumbnailImageView: UIImageView!
    @IBOutlet private weak var videoTitle: UILabel!
    @IBOutlet private weak var videoDurationButton: UIButton!
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet private weak var audioView: UIView!
    @IBOutlet private weak var videoView: UIView!

    weak var delegate: LeaderWisdomTableViewCellProtocol?

    func configure(with viewModel: LeaderWisdomCellViewModel) {
        videoView.isHidden = viewModel.video == nil
        audioView.isHidden = viewModel.audio == nil
        titleLabel.isHidden = viewModel.attributedTitle == nil
        subtitleLabel.isHidden = viewModel.attributedSubTitle == nil
        descriptionLabel.isHidden = viewModel.attributedDescription == nil
        titleLabel.attributedText = viewModel.attributedTitle
        subtitleLabel.attributedText = viewModel.attributedSubTitle
        descriptionLabel.attributedText = viewModel.attributedDescription
        videoTitle.text = viewModel.video?.title.uppercased()
        videoDurationButton.setTitle(viewModel.video?.duration, for: .normal)
        audioButton.setTitle(viewModel.audio?.duration, for: .normal)
        videoThumbnailImageView.kf.setImage(with: viewModel.video?.thumbnail, placeholder: R.image.preloading())
    }

    @IBAction func audioAction(_ sender: Any) {
        delegate?.shouldPlayAudio()
    }

    @IBAction func videoAction(_ sender: Any) {
        delegate?.shouldPlayVideo(with: nil)
    }
}
