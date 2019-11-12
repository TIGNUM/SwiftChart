//
//  TBVDataGraphBarViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TBVDataGraphBarViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var graphBarView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingTimeLabel: UILabel!
    @IBOutlet private weak var ratingLabelContainerView: UIView!
    @IBOutlet private weak var progressBarHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingLabelContainerView.circle()
    }

    func setup(with config: TBVGraph.BarGraphConfig,
               isSelected: Bool,
               ratingTime: Date?,
               rating: CGFloat,
               range: TBVGraph.Range) {

        progressBarHeightConstraint.constant = range.barHeight(for: rating)
        ratingLabelContainerView.backgroundColor = isSelected ? config.ratingCircleColor : .clear
        progressView.backgroundColor = isSelected ? config.selectedBarColor : config.progressBarColor
        graphBarView.backgroundColor = config.graphBarColor

        ratingLabel.text = rating <= 0 ? "" : String(format: "%.1f", rating)
        ratingLabel.font = isSelected ? config.selectedFont : config.unSelectedFont
        ratingLabel.textColor = isSelected ? config.selectedBarRatingColor : config.unSelectedBarRatingColor

        ratingTimeLabel.isHidden = true
        if let time = ratingTime {
            ratingTimeLabel.isHidden = false
            ratingTimeLabel.text = DateFormatter.tbvTracker.string(from: time)
        }
    }
}
