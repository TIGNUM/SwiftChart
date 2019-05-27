//
//  ToolsCollectionsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsVideoTableViewCell: UITableViewCell, Dequeueable {

     // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var mediaIconImageView: UIImageView!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var playIcon: UIImageView!
    @IBOutlet private weak var playIconBackground: UIView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        playIconBackground.corner(radius: playIconBackground.bounds.size.width/2)
    }

    func configure(title: String, timeToWatch: String, imageURL: URL?) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.5,
                                                       font: .apercuLight(ofSize: 16),
                                                       lineSpacing: 8,
                                                       textColor: .carbon,
                                                       alignment: .left)
        detailLabel.attributedText = NSAttributedString(string: timeToWatch,
                                                        letterSpacing: 0.4,
                                                        font: .apercuMedium(ofSize: 12),
                                                        textColor: UIColor.carbon.withAlphaComponent(0.4),
                                                        alignment: .left)
        previewImageView.kf.setImage(with: imageURL, placeholder: R.image.preloading())
        mediaIconImageView.image = R.image.ic_camera_tools()?.withRenderingMode(.alwaysTemplate)
    }
}
