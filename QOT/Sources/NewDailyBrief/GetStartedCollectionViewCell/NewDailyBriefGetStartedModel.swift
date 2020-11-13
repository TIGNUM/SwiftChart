//
//  NewDailyBriefGetStartedModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 04/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class NewDailyBriefGetStartedModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var title: String?
    var image: String?

    // MARK: - Init
    init(title: String?, image: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.image = image
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? NewDailyBriefGetStartedModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            image == source.image
    }

    // MARK: - Public
    override public func height(forWidth width: CGFloat) -> CGFloat {
        let titleSizingLabel = UILabel()
        titleSizingLabel.numberOfLines = 0
        titleSizingLabel.font = UIFont.sfProDisplayRegular(ofSize: 20.0)
        titleSizingLabel.lineBreakMode = .byTruncatingTail
        titleSizingLabel.text = title

        let maxTitleSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let titleSize = titleSizingLabel.sizeThatFits(maxTitleSize)

        return titleSize.height
    }
}
