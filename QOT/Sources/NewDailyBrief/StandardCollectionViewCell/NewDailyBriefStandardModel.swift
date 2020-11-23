//
//  NewDailyBriefStandardModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 04/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import qot_dal

enum CTAType {
    case normal
    case audio
    case video
}
final class NewDailyBriefStandardModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var caption: String?
    var title: NSAttributedString?
    var body: String?
    var image: String?
    var detailsMode: Bool?
    var numberOfLinesForBody: Int
    var isInAnimationTransition: Bool?
    var CTAType: ContentFormat

    // MARK: - Init
    init(caption: String?,
         title: NSAttributedString?,
         body: String?, image: String?,
         detailsMode: Bool = false,
         numberOfLinesForBody: Int = 2,
         isInAnimationTransition: Bool = false,
         CTAType: ContentFormat = .unknown,
         domainModel: QDMDailyBriefBucket?) {
        self.caption = caption
        self.title = title
        self.body = body
        self.image = image
        self.detailsMode = detailsMode
        self.numberOfLinesForBody = numberOfLinesForBody
        self.isInAnimationTransition = isInAnimationTransition
        self.CTAType = CTAType
        super.init(domainModel)
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
        titleSizingLabel.numberOfLines = 5
        titleSizingLabel.font = UIFont.sfProtextRegular(ofSize: 24.0)
        titleSizingLabel.lineBreakMode = .byTruncatingTail
        titleSizingLabel.attributedText = title

        let bodySizingLabel = UILabel()
        bodySizingLabel.numberOfLines = isInAnimationTransition ?? false ? numberOfLinesForBody : 0
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
