//
//  WhatsHotLatestCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotLatestCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var whatsHotImage: UIImageView!
    @IBOutlet private weak var whatsHotTitle: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateAndDurationLabel: UILabel!
    @IBOutlet private weak var newLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        newLabel.isHidden = true
    }

    func configure(with: WhatsHotLatestCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((with?.title ?? "").uppercased(), to: whatsHotTitle)
        ThemeText.dailyBriefSubtitle.apply(R.string.localized.dailyBriefWhatsHotSubtitle(), to: subtitle)
        whatsHotImage.kf.setImage(with: with?.image, placeholder: R.image.preloading())
        ThemeText.author.apply(with?.author, to: authorLabel)
        dateAndDurationLabel.text = DateFormatter.whatsHotBucket.string(from: with?.publisheDate ?? Date()) + " | "  + "\((with?.timeToRead ?? Int(0.0) ) / 60)" + " min read"
        if with?.isNew == true { newLabel.isHidden = false }
    }
}
