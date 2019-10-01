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
    @IBOutlet private weak var seenIcon: UIImageView?
    @IBOutlet private weak var bottomSeperator: UIView!
    let skeletonManager = SkeletonManager()

    func configure(categoryTitle: String?, viewCount: Int?, itemCount: Int?) {
        guard let title = categoryTitle, let views = viewCount, let items = itemCount else {
            return
        }
        let bkView = UIView()
        ThemeView.level1Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.hide()
        ThemeText.performanceStaticTitle.apply(R.string.localized.strategyPerformanceTitle(), to: performanceLabel)
        let titleText = title.replacingOccurrences(of: "Performance ", with: "")
        ThemeText.linkMenuItem.apply(titleText.uppercased(), to: categoryTitleLabel)
        let progress = String(format: "%d Seen of %d", views, items)
        ThemeText.datestamp.apply(progress, to: progressLabel)
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = nil
        skeletonManager.addSubtitle(performanceLabel)
        skeletonManager.addSubtitle(categoryTitleLabel)
        skeletonManager.addOtherView(progressLabel)
        if let icon = seenIcon {
            skeletonManager.addOtherView(icon)
        }
    }
}
