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
    @IBOutlet private weak var detailLabel: UILabel!

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

    func configure(title: String?, publishDate: Date?, author: String?, timeToRead: String?, imageURL: URL?) {
        whatsHotImageView.kf.setImage(with: imageURL, placeholder: R.image.preloading())
        titleLabel.attributedText = NSAttributedString(string: title ?? "",
                                                       letterSpacing: 0.5,
                                                       font: .apercuRegular(ofSize: 16),
                                                       lineSpacing: 8,
                                                       textColor: .sand,
                                                       alignment: .left)
        let dateFormatter = DateFormatter.whatsHot
        let displayDate = dateFormatter.string(from: publishDate ?? Date())
        let detailText = String(format: "%@ %@ - %@", displayDate, author ?? "", timeToRead ?? "")
        detailLabel.attributedText = NSAttributedString(string: detailText,
                                                        letterSpacing: 0.4,
                                                        font: .apercuMedium(ofSize: 12),
                                                        textColor: .sand30,
                                                        alignment: .left)
        backgroundColor = .carbon
    }
}

// MARK: - Private

private extension WhatsHotComponentView {}
