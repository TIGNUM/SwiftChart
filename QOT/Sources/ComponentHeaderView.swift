//
//  ComponentHeaderView.swift
//  QOT
//
//  Created by karmic on 02.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ComponentHeaderView: UICollectionReusableView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private var verticalConstraints: [NSLayoutConstraint]!
    @IBOutlet private var horizontalConstraints: [NSLayoutConstraint]!

    func configure(title: String?, subtitle: String?, secondary: Bool) {
        guard let title = title, let subtitle = subtitle else { return }

        let theme = secondary ? ThemeView.level1Secondary : ThemeView.level1
        ThemeText.strategyHeader.apply(title.uppercased(), to: titleLabel)
        ThemeText.strategySubHeader.apply(subtitle, to: subtitleLabel)
        theme.apply(self)
    }

    // MARK: Public

    func calculateHeight(for cellWidth: CGFloat) -> CGFloat {
        var height: CGFloat = 0
        var verticalConstraintsSum: CGFloat = 0
        var horizontalConstraintsSum: CGFloat = 0
        for constraint in verticalConstraints {
            verticalConstraintsSum += constraint.constant
        }
        for constraint in horizontalConstraints {
            horizontalConstraintsSum += constraint.constant
        }
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: cellWidth - horizontalConstraintsSum, height: .greatestFiniteMagnitude))
        let subtitleLabelSize = subtitleLabel.sizeThatFits(CGSize(width: cellWidth - horizontalConstraintsSum, height: .greatestFiniteMagnitude))

        height = titleLabelSize.height + subtitleLabelSize.height + verticalConstraintsSum

        return height
    }
}
