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

    @IBOutlet weak var headerView: UIView!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var whatsHotImage: UIImageView!
    @IBOutlet private weak var whatsHotTitle: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateAndDurationLabel: UILabel!
    @IBOutlet private weak var newLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        newLabel.isHidden = true
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
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
        //TO DO: Assign a different key for the WHAT'S HOT TITLE. Now it's using the same key as the Knowing section
        baseHeaderView?.configure(title: AppTextService.get(AppTextKey.know_section_wh_articles_title),
                                  subtitle: AppTextService.get(AppTextKey.daily_brief_section_wh_subtitle))
        skeletonManager.addOtherView(whatsHotImage)
        whatsHotImage.setImage(url: model.image,
                               skeletonManager: self.skeletonManager)
        ThemeText.author.apply(model.author, to: authorLabel)
        dateAndDurationLabel.text = DateFormatter.whatsHotBucket.string(from: model.publisheDate) + " | "  + "\((model.timeToRead) / 60)" + " min read"
        if model.isNew == true { newLabel.isHidden = false }
    }
}
