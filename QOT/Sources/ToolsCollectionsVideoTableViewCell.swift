//
//  ToolsCollectionsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsVideoTableViewCell: BaseToolsTableViewCell, Dequeueable {

     // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var mediaIconImageView: UIImageView!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var playIcon: UIImageView!
    @IBOutlet private weak var playIconBackground: UIView!
    let skeletonManager = SkeletonManager()

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        playIconBackground.corner(radius: playIconBackground.bounds.size.width/2)
    }

    func configure(title: String, timeToWatch: String, imageURL: URL?) {
        ThemeText.qotTools.apply(title, to: titleLabel)
        ThemeText.qotToolsSectionSubtitle.apply(timeToWatch, to: detailLabel)
        skeletonManager.addOtherView(previewImageView)
        previewImageView.setImage(url: imageURL, skeletonManager: self.skeletonManager) { (_) in /* */}
        mediaIconImageView.image = R.image.ic_camera_grey()
        ThemeTint.darkGrey.apply(mediaIconImageView)
    }
}
