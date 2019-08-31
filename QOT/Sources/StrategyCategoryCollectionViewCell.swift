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
        ThemeText.performanceStaticTitle.apply(R.string.localized.strategyPerformanceTitle(), to: performanceLabel)
        let title = categoryTitle.replacingOccurrences(of: "Performance ", with: "")
        ThemeText.linkMenuItem.apply(title.uppercased(), to: categoryTitleLabel)
        let progress = String(format: "%d Seen of %d", viewCount, itemCount)
        ThemeText.datestamp.apply(progress, to: progressLabel)
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let bkView = UIView()
        ThemeView.level1Selected.apply(bkView)
        selectedBackgroundView = bkView
    }
}
