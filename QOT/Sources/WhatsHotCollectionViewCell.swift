//
//  WhatsHotCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 26.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotCollectionViewCell: UICollectionViewCell, Dequeueable {
    private static let sizingCell = UINib(nibName: "WhatsHotCollectionViewCell",
                                          bundle: nil).instantiate(withOwner: nil,
                                                                   options: nil).first! as? WhatsHotCollectionViewCell
    // MARK: - Properties
    @IBOutlet private weak var whatsHotImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var newIndicatorView: UIView!
    @IBOutlet private weak var seperator: UIView!
    let skeletonManager = SkeletonManager()

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addOtherView(whatsHotImageView)
        skeletonManager.addSubtitle(titleLabel)
        skeletonManager.addSubtitle(authorLabel)
        skeletonManager.addSubtitle(detailLabel)
    }

    // MARK: - Cell configuration
    func configure(title: String?,
                   publishDate: Date?,
                   author: String?,
                   timeToRead: String?,
                   imageURL: URL?,
                   isNew: Bool?,
                   forcedColorMode: ThemeColorMode?) {
        guard let titleText = title,
                let date = publishDate,
                let authorName = author,
                let time = timeToRead,
                let new = isNew else {
                return
        }
        skeletonManager.hide()
        newIndicatorView.isHidden = (new == false)
        if whatsHotImageView.image == nil {
            skeletonManager.addOtherView(whatsHotImageView)
        }
        whatsHotImageView.setImage(url: imageURL, skeletonManager: self.skeletonManager) { (_) in /* */}

        titleLabel.text = titleText
        let dateFormatter = DateFormatter.whatsHot
        let displayDate = dateFormatter.string(from: date)
        let detailText = String(format: "%@ | %@", displayDate, time)
        detailLabel.text = detailText
        authorLabel.text = authorName
        ThemeView.articleBackground(forcedColorMode).apply(self)
        ThemeView.articleSeparator(forcedColorMode).apply(seperator)
    }

    // MARK: Public

    public static func height(title: String,
                              publishDate: Date?,
                              author: String?,
                              timeToRead: String?,
                              forWidth width: CGFloat) -> CGFloat {
        sizingCell?.prepareForReuse()
        sizingCell?.configure(title: title,
                              publishDate: publishDate,
                              author: author,
                              timeToRead: timeToRead,
                              imageURL: nil,
                              isNew: false,
                              forcedColorMode: .dark)
        sizingCell?.layoutIfNeeded()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        guard let size = sizingCell?.systemLayoutSizeFitting(fittingSize,
                                                             withHorizontalFittingPriority: .required,
                                                             verticalFittingPriority: .defaultLow) else {
            return .zero
        }

        guard size.height < maximumHeight else {
            return maximumHeight
        }

        return size.height
    }
}
