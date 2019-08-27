//
//  WhatsHotComponentView.swift
//  QOT
//
//  Created by karmic on 26.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotComponentView: ComponentContentView, NibLoadable {

    // MARK: - Properties

    @IBOutlet private weak var whatsHotImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var newIndicatorView: UIView!
    @IBOutlet private weak var seperator: UIView!

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
        detailLabel.preferredMaxLayoutWidth = detailLabel.bounds.width
    }

    // MARK: - Cell configuration

    func configure(title: String?,
                   publishDate: Date?,
                   author: String?,
                   timeToRead: String?,
                   imageURL: URL?,
                   isNew: Bool,
                   colorMode: ColorMode) {
        newIndicatorView.isHidden = (isNew == false)
        whatsHotImageView.kf.setImage(with: imageURL, placeholder: R.image.preloading())

        ThemeText.whatsHotHeader.apply(title ?? "", to: titleLabel)
        let dateFormatter = DateFormatter.whatsHot
        let displayDate = dateFormatter.string(from: publishDate ?? Date())
        let detailText = String(format: "%@ | %@", displayDate, timeToRead ?? "")
        ThemeText.datestamp.apply(detailText, to: detailLabel)
        ThemeText.author.apply(author ?? "", to: authorLabel)
        backgroundColor = colorMode.background
        seperator.backgroundColor = colorMode.seperator
    }
}
