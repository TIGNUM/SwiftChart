//
//  ToolsCollectionsGroupTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 22.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsGroupTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var mediaIconImageView: UIImageView!
    @IBOutlet private weak var counterView: UIView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var counterImageView: UIImageView!
    private var mediaURL: URL?
    private var title: String?
    private var remoteID: Int = 0
    private var categoryTitle = ""
    private var type = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        counterView.corner(radius: 20)
        counterLabel.corner(radius: counterLabel.bounds.size.width/2)
    }

    func configure(categoryTitle: String,
                   title: String,
                   timeToWatch: String,
                   mediaURL: URL?,
                   duration: Double,
                   remoteID: Int,
                   numberOfItems: Int,
                   type: String) {
        self.categoryTitle = categoryTitle
        self.mediaURL = mediaURL
        self.title = title
        self.remoteID = remoteID
        self.type = type
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.5,
                                                       font: .apercuLight(ofSize: 16),
                                                       lineSpacing: 8,
                                                       textColor: .carbon,
                                                       alignment: .left)
        detailLabel.attributedText = NSAttributedString(string: "\(numberOfItems)" + " items",
                                                        letterSpacing: 0.4,
                                                        font: .apercuMedium(ofSize: 12),
                                                        textColor: UIColor.carbon.withAlphaComponent(0.4),
                                                        alignment: .left)
        mediaIconImageView.image = R.image.ic_group_grey()
        counterLabel.attributedText = NSAttributedString(string: "\(numberOfItems)",
                                                       letterSpacing: 0.4,
                                                       font: .apercuMedium(ofSize: 12),
                                                       textColor: .carbon,
                                                       alignment: .center)
    }
}
