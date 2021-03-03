//
//  StrategyCategoryCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 02.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class StrategyCategoryCollectionViewCell: ComponentCollectionViewCell {

    // MARK: - Properties
    @IBOutlet private weak var performanceLabel: UILabel!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var seenIcon: UIImageView?
    @IBOutlet private weak var bottomSeperator: UIView!
    @IBOutlet weak var bottomSeparatorTopConstraint: NSLayoutConstraint!
    let skeletonManager = SkeletonManager()

    func configure(categoryTitle: String?,
                   viewCount: Int?,
                   itemCount: Int?,
                   contentType: CTAType = .normal,
                   shouldShowSeparator: Bool = false) {
        guard let title = categoryTitle, let views = viewCount, let items = itemCount else {
            return
        }
        let bkView = UIView()
        ThemeView.level1Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.hide()
        ThemeText.performanceStaticTitle.apply(AppTextService.get(.know_section_strategies_title_performance).lowercased().capitalizingFirstLetter(),
                                               to: performanceLabel)
        let titleText = title.replacingOccurrences(of: "Performance ", with: String.empty)
        categoryTitleLabel.text = titleText
        let progress = String(format: "%d Seen of %d", views, items)
        ThemeText.datestamp.apply(progress, to: progressLabel)
        bottomSeperator.isHidden = !shouldShowSeparator
        bottomSeparatorTopConstraint.constant = shouldShowSeparator ? 27.0 : .zero
        switch contentType {
        case .normal:
            seenIcon?.image = UIImage.init(named: R.image.ic_seen_of.name)
        case .audio:
            seenIcon?.image = UIImage.init(named: R.image.ic_audio.name)
        case .video:
            seenIcon?.image = UIImage.init(named: R.image.ic_camera_grey.name)
        }
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
