//
//  StrategyTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var progressView: UIView!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
        progressView.corner(radius: Layout.CornerRadius.eight.rawValue)
    }

    func configure(title: String, remoteID: Int, percentageLearned: Double, viewedCount: Int, itemCount: Int) {
        titleLabel.text = title
        subtitleLabel.text = String(format: "%d/%d", viewedCount, itemCount)
    }
}
