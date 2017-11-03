//
//  LearnContentItemRecommendedCell.swift
//  QOT
//
//  Created by karmic on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentItemRecommendedCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentTitleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var roundedContentView: UIView!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var finishButton: UIButton!
    weak var delegate: LearnContentItemViewControllerDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        roundedContentView.layer.cornerRadius = 8
    }

    // MARK: - Setup

    func setup(contentTitle: String, minutes: Int, previewImage: UIImage) {
//        let attributedContentString =
    }
}

// MARK: - Actions

private extension LearnContentItemRecommendedCell {

    @IBAction func clickToFinishTapped(sender: UIButton) {
        delegate?.didTapFinish(from: contentView)
    }
}
