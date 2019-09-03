//
//  ExploreCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ExploreCell: BaseDailyBriefCell {

    @IBOutlet private weak var timeOfDayPosition: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introTextLabel: UILabel!
    @IBOutlet weak var strategyView: UIView!

    func configure(title: String?, introText: String?, labelPosition: CGFloat?) {
        ThemeView.level2.apply(self)
        ThemeText.bespokeText.apply(introText, to: introTextLabel)
        ThemeText.strategyTitle.apply((title ?? "").uppercased(), to: titleLabel)
        timeOfDayPosition.constant = labelPosition ?? 0
    }
}
