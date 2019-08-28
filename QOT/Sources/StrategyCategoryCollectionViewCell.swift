//
//  StrategyCategoryCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 02.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class StrategyCategoryCollectionViewCell: ComponentCollectionViewCell {

    // MARK: - Properties

    @IBOutlet private weak var performanceLabel: UILabel!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var bottomSeperator: UIView!

    func configure(categoryTitle: String, viewCount: Int, itemCount: Int) {
        ThemeText.performanceStaticTitle.apply("PERFORMANCE", to: performanceLabel)

        let title = categoryTitle.replacingOccurrences(of: "Performance ", with: "")
        ThemeText.linkMenuItem.apply(title, to: categoryTitleLabel)

        let progress = String(format: "%d Seen of %d", viewCount, itemCount)
        ThemeText.datestamp.apply(progress, to: progressLabel)
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        let bkView = UIView()
        bkView.backgroundColor = .accent04
        selectedBackgroundView = bkView
    }
}
