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
    var appLink: QDMAppLink?
    var isCompleted: Bool?

    // MARK: - Init
    init(title: String?, image: String?, appLink: QDMAppLink?, isCompleted: Bool?, domainModel: QDMDailyBriefBucket?) {
        self.appLink = appLink
        self.isCompleted = isCompleted
        super.init(domainModel, title: title, image: image)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? NewDailyBriefGetStartedModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            image == source.image &&
            appLink?.url() == source.appLink?.url()
    }

    // MARK: - Public
    override public func height(forWidth width: CGFloat) -> CGFloat {
        let titleSizingLabel = UILabel()
        titleSizingLabel.numberOfLines = .zero
        titleSizingLabel.font = UIFont.sfProDisplayRegular(ofSize: 20.0)
        titleSizingLabel.lineBreakMode = .byTruncatingTail
        titleSizingLabel.text = title

        let maxTitleSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let titleSize = titleSizingLabel.sizeThatFits(maxTitleSize)

        return titleSize.height
    }
}
