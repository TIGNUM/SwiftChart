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

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var contentTitleLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var roundedContentView: UIView!
    @IBOutlet fileprivate weak var previewImageView: UIImageView!
    @IBOutlet fileprivate weak var finishButton: UIButton!
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
