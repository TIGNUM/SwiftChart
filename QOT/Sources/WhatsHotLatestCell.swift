//
//  WhatsHotLatestCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(subtitle)
        skeletonManager.addOtherView(whatsHotImage)
        skeletonManager.addSubtitle(whatsHotTitle)
        skeletonManager.addSubtitle(authorLabel)
        skeletonManager.addSubtitle(dateAndDurationLabel)
        skeletonManager.addSubtitle(newLabel)

    }

    func configure(with: WhatsHotLatestCellViewModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply(model.title.uppercased(), to: whatsHotTitle)
        ThemeText.dailyBriefSubtitle.apply(AppTextService.get(AppTextKey.daily_brief_whats_hot_view_subtitle_title), to: subtitle)
        skeletonManager.addOtherView(whatsHotImage)
        whatsHotImage.setImage(url: model.image,
                               skeletonManager: self.skeletonManager)
        ThemeText.author.apply(model.author, to: authorLabel)
        dateAndDurationLabel.text = DateFormatter.whatsHotBucket.string(from: model.publisheDate) + " | "  + "\((model.timeToRead) / 60)" + " min read"
        if model.isNew == true { newLabel.isHidden = false }
    }
}
