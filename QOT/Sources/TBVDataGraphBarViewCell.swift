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

    let barHeight: CGFloat = 202

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingLabelContainerView.corner(radius: ratingLabelContainerView.frame.size.width/2)
    }

    func setup(with config: TBVGraph.BarGraphConfig, isSelected: Bool, ratingTime: Date?, rating: CGFloat, range: TBVGraph.Range) {
        self.ratingLabelContainerView.clipsToBounds = false
        ratingLabel.text = rating == 0 ? "" : String(format: "%.1f", rating)
        ratingLabel.font = isSelected ? config.selectedFont : config.unSelectedFont
        ratingLabel.textColor = isSelected ? config.selectedBarRatingColor : config.unSelectedBarRatingColor
        progressView.backgroundColor = isSelected ? config.selectedBarColor : config.progressBarColor
        ratingLabelContainerView.backgroundColor = !isSelected ? .clear : config.ratingCircleColor
        graphBarView.backgroundColor = config.graphBarColor
        let height = (barHeight / CGFloat(range.final)) * rating
        progressBarHeightConstraint.constant = height
        ratingTimeLabel.isHidden = false
        guard let time = ratingTime else {
            ratingTimeLabel.isHidden = true
            return
        }
        ratingTimeLabel.text = DateFormatter.tbvTracker.string(from: time)
    }
}
