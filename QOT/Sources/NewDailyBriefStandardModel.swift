//
//  NewDailyBriefStandardModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 04/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import qot_dal

final class NewDailyBriefStandardModel: NewBaseDailyBriefModel {

    // MARK: - Properties
    var caption: String?
    var title: String?
    var body: String?
    var image: String?

    // MARK: - Init
    init(caption: String?, title: String?, body: String?, image: String?, domainModel: QDMDailyBriefBucket?) {
        self.caption = caption
        self.title = title
        self.body = body
        self.image = image
        super.init(domainModel: domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? NewDailyBriefStandardModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            caption == source.caption &&
            title == source.title &&
            body == source.body &&
            image == source.image
    }

    // MARK: - Public
    override func height(forWidth width: CGFloat) -> CGFloat {
        let captionSizingLabel = UILabel()
        captionSizingLabel.numberOfLines = 3
        captionSizingLabel.font = UIFont.sfProtextRegular(ofSize: 14.0)
        captionSizingLabel.lineBreakMode = .byTruncatingTail
        captionSizingLabel.text = caption

        let titleSizingLabel = UILabel()
        titleSizingLabel.numberOfLines = 3
        titleSizingLabel.font = UIFont.sfProtextRegular(ofSize: 24.0)
        titleSizingLabel.lineBreakMode = .byTruncatingTail
        titleSizingLabel.text = title

        let bodySizingLabel = UILabel()
        bodySizingLabel.numberOfLines = 0
        bodySizingLabel.font = UIFont.sfProtextRegular(ofSize: 16.0)
        bodySizingLabel.lineBreakMode = .byTruncatingTail
        bodySizingLabel.text = body

        let maxCaptionSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let maxTitleSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let maxBodySize = CGSize(width: width - 25.0, height: .greatestFiniteMagnitude)

        let captionSize = captionSizingLabel.sizeThatFits(maxCaptionSize)
        let titleSize = titleSizingLabel.sizeThatFits(maxTitleSize)
        let bodySize = bodySizingLabel.sizeThatFits(maxBodySize)

        return captionSize.height + titleSize.height + bodySize.height
    }
}
